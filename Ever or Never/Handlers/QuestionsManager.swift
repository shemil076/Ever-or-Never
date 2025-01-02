//
//  QuestionsManager.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-12.
//

import Foundation
import FirebaseFirestore


final class QuestionsManager {
    static let shared = QuestionsManager()
    
    private init() {
        
    }
    
    let questionsCollection = Firestore.firestore().collection("questions")
    
    private func questionsDocument(quizSessionId: String) -> DocumentReference {
        questionsCollection.document(quizSessionId)
    }
    
    func loadQustionsFromJSON() -> [CodableQuestion]? {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            print("Error: JSON file not found")
            return nil
        }
        print("JSON file URL: \(url)") 
        
        do{
            let data = try Data(contentsOf: url)
            let questions = try JSONDecoder().decode([CodableQuestion].self, from: data)
            return questions
        }catch{
            print("Error decoding JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    func populateQuestionsCollection() {
        guard let questions = loadQustionsFromJSON() else {
            print("No Questions to upload")
            return
        }
        
        for question in questions {
            print("Going to populated questions collection")
            var ref : DocumentReference? = nil
            
            ref = questionsCollection.addDocument(data: [
                "question": question.question,
                "category": question.category.rawValue,
                "suitableForAbove": question.suitableForAbove
            ]) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                }else{
                    guard let documentID = ref?.documentID else {
                        print("Error: Could not get document ID")
                        return
                    }
                    
                    ref?.updateData([
                        "id": documentID
                    ]) {
                        error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        }else {
                            print("Document successfully updated")
                        }
                    }
                }
                
            }
        }
    }
    
    
    
    //    func fetchQuestions() async throws -> [Question] {
    //        let snapShot = try await questionsCollection.limit(to: 10).getDocuments()
    //        
    //        let questions = try snapShot.documents.compactMap{ document in
    //            try document.data(as : Question.self)
    //        }
    //        print("Questions fetched: \(questions)")
    //        return questions
    //    }
    
    //    func fetchQuestions(categoriers: [QuestionCategory], totalQuestionCount: Int) async throws -> [Question] {
    //        let baseCountPerCategory = totalQuestionCount / categoriers.count
    //        var remainingQuestionCount = totalQuestionCount % categoriers.count
    //        
    //        print("baseCountPerCategory: \(baseCountPerCategory)")
    //        
    //    print("remainingQuestionCount: \(remainingQuestionCount)")
    //        
    //        var questions: [Question] = []
    //        
    //        
    //        for category in categoriers {
    //            
    //            let questionCountForCategory = baseCountPerCategory + (remainingQuestionCount > 0 ? 1 : 0)
    //            if remainingQuestionCount > 0 {
    //                remainingQuestionCount -= 1
    //            }
    //            
    //            let snapShot = try await questionsCollection.whereField("category", isEqualTo: category.rawValue).limit(to: questionCountForCategory).getDocuments()
    //            
    //            let categoryQuestions = try snapShot.documents.compactMap{ document in
    //                    try document.data(as : Question.self)
    //            }
    //            
    //            questions.append(contentsOf: categoryQuestions)
    //        }
    //        
    //        print ("Questions fetched: \(questions)")
    //        
    //        questions.shuffle()
    //        print("questions cound is \(questions.count)")
    //        
    //        return questions
    //    }
    
    
    func fetchQuestions(categoriers: [QuestionCategory], totalQuestionCount: Int) async throws -> [Question]{
        
        print("loading questions")
        var questions: [Question] = []
        var remainingQuestionCount = totalQuestionCount
        var shortFallQuestions: [Question] = []
        
        for category in categoriers {
            
            let questionCountForCategory = remainingQuestionCount / (categoriers.count - questions.count / (totalQuestionCount / categoriers.count))
            
            let snapShot = try await questionsCollection
                .whereField("category", isEqualTo: category.rawValue)
                .limit(to: questionCountForCategory)
                .getDocuments()
            
            let categoryQuestions = try snapShot.documents.compactMap{ document in
                try document.data(as : Question.self)
            }
            
            questions.append(contentsOf: categoryQuestions)
            remainingQuestionCount -= categoryQuestions.count
            
            
            if categoryQuestions.count < questionCountForCategory {
                shortFallQuestions.append(contentsOf: categoryQuestions)
            }
        }
        
        if remainingQuestionCount > 0 {
            let extraSnapShot = try await questionsCollection.limit(to: remainingQuestionCount).getDocuments()
            let extraQuestions = try extraSnapShot.documents.compactMap{ document in
                try document.data(as : Question.self)
            }
            
            questions.append(contentsOf: extraQuestions)
        }
        
        questions.shuffle()
        
        
        return Array(questions.prefix(totalQuestionCount))
        
    }
    
    
    //    TODO: Check the below function after adding new questions to the question pool
    
    //    func fetchRandomUniqueQuestions(userSeenQuestions: Set<String>, categoriers: [QuestionCategory], totalQuestionCount: Int) async throws -> [Question] {
    //        print("Loading fresh questions...")
    //        
    //        var questions: [Question] = []
    //        var remainingQuestionCount = totalQuestionCount
    //        var fetchedQuestionIds: Set<String> = []
    //        
    //        // Fetch questions from each category
    //        for category in categoriers {
    //            var lastDocumentSnapshot: DocumentSnapshot? = nil
    //            
    //            while remainingQuestionCount > 0 {
    //                var query = questionsCollection
    //                    .whereField("category", isEqualTo: category.rawValue)
    //                    .limit(to: 20)
    //                
    //                if let lastSnapshot = lastDocumentSnapshot {
    //                    query = query.start(afterDocument: lastSnapshot)
    //                }
    //                
    //                let snapshot = try await query.getDocuments()
    //                let categoryQuestions = try snapshot.documents.compactMap { document in
    //                    try document.data(as: Question.self)
    //                }
    //                
    //                if categoryQuestions.isEmpty {
    //                    break
    //                }
    //                
    //                var availableQuestions = categoryQuestions.shuffled()
    //                var addedCount = 0 // Tracks how many questions are added in this iteration
    //                
    //                while !availableQuestions.isEmpty && remainingQuestionCount > 0 {
    //                    let randomIndex = Int.random(in: 0..<availableQuestions.count)
    //                    let question = availableQuestions.remove(at: randomIndex)
    //                    
    //                    if !userSeenQuestions.contains(question.id) && !fetchedQuestionIds.contains(question.id) {
    //                        questions.append(question)
    //                        fetchedQuestionIds.insert(question.id)
    //                        remainingQuestionCount -= 1
    //                        addedCount += 1
    //                    }
    //                }
    //                
    //                if addedCount == 0 {
    //                    break // Avoid infinite loop if no new questions are added
    //                }
    //                
    //                lastDocumentSnapshot = snapshot.documents.last
    //            }
    //        }
    //        
    //        // Fetch additional questions to fill the gap
    //        while remainingQuestionCount > 0 {
    //            
    //            var categoriyRawValues : [String] = []
    //            
    //            for category in categoriers {
    //                categoriyRawValues.append(category.rawValue)
    //            }
    //            
    //    
    //            let extraSnapshot = try await questionsCollection
    //                .whereField("category", notIn: categoriyRawValues)
    //                .limit(to: remainingQuestionCount).getDocuments()
    //            let extraQuestions = try extraSnapshot.documents.compactMap { document in
    //                try document.data(as: Question.self)
    //            }
    //            
    //            if extraQuestions.isEmpty {
    //                print("no more questions available")
    //                break // No more questions available
    //            }
    //            
    //            var availableQuestions = extraQuestions.shuffled()
    //            var addedCount = 0 // Tracks how many questions are added in this iteration
    //            
    //            while !availableQuestions.isEmpty && remainingQuestionCount > 0 {
    //                let randomIndex = Int.random(in: 0..<availableQuestions.count)
    //                let question = availableQuestions.remove(at: randomIndex)
    //                
    //                if !userSeenQuestions.contains(question.id) && !fetchedQuestionIds.contains(question.id) {
    //                    questions.append(question)
    //                    fetchedQuestionIds.insert(question.id)
    //                    remainingQuestionCount -= 1
    //                    addedCount += 1
    //                }
    //            }
    //            
    //            if addedCount == 0 {
    //                break // Avoid infinite loop if no new questions are added
    //            }
    //        }
    //        
    //        print("Fetched \(questions.count) unique questions out of \(totalQuestionCount) requested.")
    //        return questions
    //    }
    
    func fetchRandomUniqueQuestions(userSeenQuestions: inout Set<String>, categories: [QuestionCategory], totalQuestionCount: Int, userId: String) async throws -> [Question] {
        print("Loading fresh questions...")
        
        var questions: [Question] = []
        var remainingQuestionCount = totalQuestionCount
        var fetchedQuestionIds: Set<String> = []
        
        // Helper to fetch questions for a category
        func fetchQuestions(for categories: [QuestionCategory], excludingSeen: Bool) async throws -> [Question] {
            var resultQuestions: [Question] = []
            var lastDocumentSnapshot: DocumentSnapshot? = nil
            
            for category in categories {
                while remainingQuestionCount > 0 {
                    var query = questionsCollection
                        .whereField("category", isEqualTo: category.rawValue)
                        .limit(to: 20)
                    
                    if let lastSnapshot = lastDocumentSnapshot {
                        query = query.start(afterDocument: lastSnapshot)
                    }
                    
                    let snapshot = try await query.getDocuments()
                    let categoryQuestions = try snapshot.documents.compactMap { document in
                        try document.data(as: Question.self)
                    }
                    
                    if categoryQuestions.isEmpty {
                        break
                    }
                    
                    var availableQuestions = categoryQuestions.shuffled()
                    while !availableQuestions.isEmpty && remainingQuestionCount > 0 {
                        let randomIndex = Int.random(in: 0..<availableQuestions.count)
                        let question = availableQuestions.remove(at: randomIndex)
                        
                        if (!userSeenQuestions.contains(question.id) || !excludingSeen) && !fetchedQuestionIds.contains(question.id) {
                            resultQuestions.append(question)
                            fetchedQuestionIds.insert(question.id)
                            remainingQuestionCount -= 1
                        }
                    }
                    
                    lastDocumentSnapshot = snapshot.documents.last
                }
            }
            
            return resultQuestions
        }
        
        // First attempt: fetch questions excluding seen ones
        questions = try await fetchQuestions(for: categories, excludingSeen: true)
        
        // Attempt to fetch additional questions from categories not specified
        if questions.count < totalQuestionCount {
            let excludedCategories = categories.map { $0.rawValue }
            let extraSnapshot = try await questionsCollection
                .whereField("category", notIn: excludedCategories)
                .limit(to: remainingQuestionCount).getDocuments()
            let extraQuestions = try extraSnapshot.documents.compactMap { document in
                try document.data(as: Question.self)
            }
            
            if !extraQuestions.isEmpty {
                var availableQuestions = extraQuestions.shuffled()
                while !availableQuestions.isEmpty && remainingQuestionCount > 0 {
                    let randomIndex = Int.random(in: 0..<availableQuestions.count)
                    let question = availableQuestions.remove(at: randomIndex)
                    
                    if !userSeenQuestions.contains(question.id) && !fetchedQuestionIds.contains(question.id) {
                        questions.append(question)
                        fetchedQuestionIds.insert(question.id)
                        remainingQuestionCount -= 1
                    }
                }
            }
        }
        
        // If still not enough questions, reset seen questions and refetch
        if questions.count < totalQuestionCount {
            print("Not enough unique questions found, resetting seen questions...")
            userSeenQuestions.removeAll()
            try await UserManager.shared.resetSeenQuestions(id: userId)
            
            // Reset remaining question count and retry fetching
            remainingQuestionCount = totalQuestionCount - questions.count
            let additionalQuestions = try await fetchQuestions(for: categories, excludingSeen: false)
            questions.append(contentsOf: additionalQuestions)
        }
        
        print("Fetched \(questions.count) unique questions out of \(totalQuestionCount) requested.")
        return questions
    }
}
