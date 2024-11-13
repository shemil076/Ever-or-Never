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

    
    
    func fetchQuestions() async throws -> [Question] {
        let snapShot = try await questionsCollection.limit(to: 10).getDocuments()
        
        let questions = try snapShot.documents.compactMap{ document in
            try document.data(as : Question.self)
        }
        print("Questions fetched: \(questions)")
        return questions
    }
    
    
}



//private func singlePlayerDocument(quizSessionId: String) -> DocumentReference {
//    singlePlayerSectionsCollection.document(quizSessionId)
//}


//static let shared = UserManager()
//
//private init() {
//
//}
//
//private let userCollection = Firestore.firestore().collection("users")
