//
//  MultiplayerSessionManager.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-18.
//

import Foundation
import FirebaseFirestore

struct MultiplayerQuizSession: Codable{
    var id: String
    let dateCreated: Date
    let hostId: String
    let numberOfQuestions: Int
    let questionCategories: [QuestionCategory]
    let questionsAndAnswers: [MultiplayerQuestionAnswer]
    let participants: [String]
    let questions : [Question]
    let isGameEnded: Bool
    let isGameStarted: Bool
    let currentQuestionIndex: Int
    let previousQuestionIndex: Int
    
    
    init(id: String = "", dateCreated: Date, hostId: String, numberOfQuestions: Int, questionCategories: [QuestionCategory], questionsAndAnswers: [MultiplayerQuestionAnswer], participants: [String], questions: [Question], isGameEnded: Bool, isGameStarted: Bool, currentQuestionIndex: Int, previousQuestionIndex: Int) {
        self.id = id
        self.dateCreated = dateCreated
        self.hostId = hostId
        self.numberOfQuestions = numberOfQuestions
        self.questionCategories = questionCategories
        self.questionsAndAnswers = questionsAndAnswers
        self.participants = participants
        self.questions = questions
        self.isGameEnded = isGameEnded
        self.isGameStarted = isGameStarted
        self.currentQuestionIndex = currentQuestionIndex
        self.previousQuestionIndex = previousQuestionIndex
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.hostId, forKey: .hostId)
        try container.encode(self.numberOfQuestions, forKey: .numberOfQuestions)
        try container.encode(self.questionCategories, forKey: .questionCategories)
        try container.encode(self.questionsAndAnswers, forKey: .questionsAndAnswers)
        try container.encode(self.participants, forKey: .participants)
        try container.encode(self.questions, forKey: .questions)
        try container.encode(self.isGameEnded, forKey: .isGameEnded)
        try container.encode(self.isGameStarted, forKey: .isGameStarted)
        try container.encode(self.currentQuestionIndex, forKey: .currentQuestionIndex)
        try container.encode(self.previousQuestionIndex, forKey: .previousQuestionIndex)
    }
    
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case dateCreated = "dateCreated"
        case hostId = "hostId"
        case numberOfQuestions = "numberOfQuestions"
        case questionCategories = "questionCategories"
        case questionsAndAnswers = "questionsAndAnswers"
        case participants = "participants"
        case questions = "questions"
        case isGameEnded = "isGameEnded"
        case isGameStarted = "isGameStarted"
        case currentQuestionIndex = "currentQuestionIndex"
        case previousQuestionIndex = "previousQuestionIndex"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated) ?? Date()
        self.hostId = try container.decodeIfPresent(String.self, forKey: .hostId) ?? ""
        self.numberOfQuestions = try container.decodeIfPresent(Int.self, forKey: .numberOfQuestions) ?? 0
        self.questionCategories = try container.decodeIfPresent([QuestionCategory].self, forKey: .questionCategories) ?? []
        self.questionsAndAnswers = try container.decodeIfPresent([MultiplayerQuestionAnswer].self, forKey: .questionsAndAnswers) ?? []
        self.participants = try container.decodeIfPresent([String].self, forKey: .participants) ?? []
        self.questions = try container.decodeIfPresent([Question].self, forKey: .questions) ?? []
        self.isGameEnded = try container.decodeIfPresent(Bool.self, forKey: .isGameEnded) ?? false
        self.isGameStarted = try container.decodeIfPresent(Bool.self, forKey: .isGameStarted) ?? false
        self.currentQuestionIndex = try container.decodeIfPresent(Int.self, forKey: .currentQuestionIndex) ?? 0
        self.previousQuestionIndex = try container.decodeIfPresent(Int.self, forKey: .previousQuestionIndex) ?? 0
    }
    
}

final class MultiplayerSessionManager{
    static let shared = MultiplayerSessionManager()
    
    
    private init() {
        
    }
    
    private let multiplayerSessionCollection = Firestore.firestore().collection("multiplayerSession")
    
    //    private var dbListener: ListenerRegistration?
    
    
    func createMultiplayerSession(hostId: String, numberOfQuestions: Int, qustionCategories: [QuestionCategory], qustions: [Question] ) async throws -> (sessionId: String?, hostId: String){
        print("Inside this function")
        var newSession = MultiplayerQuizSession(
            dateCreated: Date(),
            hostId: hostId,
            numberOfQuestions: numberOfQuestions,
            questionCategories: qustionCategories,
            questionsAndAnswers: [],
            participants: [hostId],
            questions:  qustions,
            isGameEnded: false,
            isGameStarted: false,
            currentQuestionIndex: 0,
            previousQuestionIndex: 0
        )
        
        var sessionId: String?
        
        do {
            let data = try Firestore.Encoder().encode(newSession)
            
            let documentRef = try await multiplayerSessionCollection.addDocument(data: data)
            sessionId = documentRef.documentID
            
            try await documentRef.updateData(["id": sessionId!])
            
            newSession.id = sessionId!
            print("Session created successfully with ID: \(sessionId!)")
            
            return (sessionId, hostId)
        }catch{
            print("Error creating initial quiz session: \(error.localizedDescription)")
            throw error
//            return (sessionId, hostId)
        }
    }
    
    
    func joinMultiplayerSession(sessionId: String, userId: String) async throws {
        
        let fetchedSession = try await fetchSession(sessionId: sessionId)
        
        
        if fetchedSession.isGameStarted || fetchedSession.isGameEnded{
            print("Session \(sessionId) has already started")
            throw NSError(domain: "MultiplayerSession", code: -1, userInfo: [NSLocalizedDescriptionKey: "Session  has already started"])
        }
        
        
        let sessionRef = multiplayerSessionCollection.document(sessionId)
        
//        sessionRef.updateData([
//            "participants": FieldValue.arrayUnion([userId])
//        ]){ error in
//            if let error = error {
//                print("Error occured while joining multiplayer session: \(error.localizedDescription)")
//            }
//            print("Player \(userId) successfully joined the multiplayer session \(sessionId).")
//        }
        
        do {
           try await sessionRef.updateData([
                "participants": FieldValue.arrayUnion([userId])
            ])
            print("Player \(userId) successfully joined the multiplayer session \(sessionId).")
            
        }catch{
            print("Error occured while joining multiplayer session: \(error.localizedDescription)")
            throw error
        }
    }
    
    
    func observeParticipants(sessionId : String, onUpdate: @escaping ([String]) -> Void, onError: @escaping (Error)-> Void){
        let sessionRef = multiplayerSessionCollection.document(sessionId)
        
        sessionRef.addSnapshotListener { snapshot, error in
            if let error = error {
                onError(error)
            }
            
            guard let snapshot = snapshot,
                  let data = snapshot.data(),
                  let participants = data["participants"] as? [String] else {
                onError(NSError(domain: "MultiplayerSession", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid participants data."]))
                return
            }
            
            onUpdate(participants)
        }
    }
    
    func fetchSession(sessionId: String) async throws -> MultiplayerQuizSession {
        let document = try await multiplayerSessionCollection.document(sessionId).getDocument()
        
        //        print("Found the document")
        
        guard let data = document.data() else {
            print("No data related to session Id \(sessionId) was found")
            throw NSError(domain: "MultiplayerSession", code: -1, userInfo: [NSLocalizedDescriptionKey: "Session not found."])
        }
        
        //        print("Trying to decode the data")
        
        do {
            // Attempt to decode the session data
            let session = try Firestore.Decoder().decode(MultiplayerQuizSession.self, from: data)
            //            print("Session re-fetched successfully: \(session)")
            return session
        } catch {
            // Catch and print the decoding error
            print("Decoding error: \(error)")
            throw NSError(domain: "MultiplayerSession", code: -2, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(error.localizedDescription)"])
        }
    }
    
    
    func submitAnswer(sessionId: String, questionId: String, question: String, answer: Bool, userId: String) async throws -> MultiplayerQuizSession {
        let documentRef =  multiplayerSessionCollection.document(sessionId)
        
        let sessionSnapShot = try await documentRef.getDocument()
        
        guard let sessionData = sessionSnapShot.data() else {
            throw NSError(domain: "Session not found", code: 404)
        }
        
        var questionsAndAnswers = sessionData["questionsAndAnswers"] as? [[String: Any]] ?? []
        
        if let questionIndex = questionsAndAnswers.firstIndex(where: { $0["question"] as? String == question}){
            var questionData = questionsAndAnswers[questionIndex]
            var answers = questionData["answers"] as? [[String: Any]] ?? []
            
            let newAnswer: [String: Any] = [
                "id": UUID().uuidString,
                "playerId" : userId,
                "answer" : answer
            ]
            answers.append(newAnswer)
            
            questionData["answers"] = answers
            questionsAndAnswers[questionIndex] = questionData
        }else{
            let newQuestion: [String: Any] = [
                "question" : question,
                "id": questionId,
                "answers" : [
                    [
                        "id": UUID().uuidString,
                        "playerId" : userId,
                        "answer" : answer
                    ]
                ]
            ]
            
            questionsAndAnswers.append(newQuestion)
        }
        
        try await documentRef.updateData(["questionsAndAnswers": questionsAndAnswers])
        
        print("Answer successfully submitted for question '\(question)' in session \(sessionId).")
        return try await fetchSession(sessionId: sessionId)
        
    }
    
    func updateQuestionIndexes(for sessionId: String) async throws{
        print("called updateQuestionIndexes")
        let sessionRef = multiplayerSessionCollection.document(sessionId)
        
        let sessionSnapShot = try await sessionRef.getDocument()
        
        guard let sessionData = sessionSnapShot.data() else {
            throw NSError(domain: "Session not found", code: 404)
        }
        
        print("sesionData: \(sessionData)")
        
        let questionData = sessionData["questions"] as? [[String : Any]] ?? []
        
        let questions = try questionData.compactMap{ data -> Question? in
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                return try JSONDecoder().decode(Question.self, from: jsonData)
            }
            catch {
                print("Failed to decode question: \(error)")
                throw error
            }
            
        }
        var currentQuestionIndex = sessionData["currentQuestionIndex"] as? Int ?? 0
        let previousQuestionIndex = currentQuestionIndex
            
        
        if currentQuestionIndex < questions.count {
            currentQuestionIndex = currentQuestionIndex + 1
        }
        
        try await sessionRef.updateData([
            "currentQuestionIndex" : currentQuestionIndex,
            "previousQuestionIndex" : previousQuestionIndex
        ])
        
        print("Successfully updated question index")
    }
    
    
    func observeSession(
        for sessionId: String,
        lookingFor: LookingFor,
        onUpdate: @escaping (Any) -> Void,
        onError: @escaping (Error) -> Void
    ) {
        let sessionRef = multiplayerSessionCollection.document(sessionId)
        
        sessionRef.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error fetching session data: \(error.localizedDescription)")
                onError(error)
                return
            }
            
            if lookingFor == LookingFor.forStates{
                guard let snapshot = snapshot,
                      let sessionData = snapshot.data(),
                      let isGameStarted = sessionData["isGameStarted"] as? Bool,
                      let isGameEnded = sessionData["isGameEnded"] as? Bool else {
                    onError(NSError(domain: "MultiplayerSession", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid session data."]))
                    return
                }
                
                print("Session state updated: isGameStarted = \(isGameStarted), isGameEnded = \(isGameEnded)")
                onUpdate((isGameStarted, isGameEnded))
            }
            
            if lookingFor == LookingFor.forAnswer{
                guard let snapshot = snapshot,
                      let sessionData = snapshot.data(),
                      let answers = sessionData["questionsAndAnswers"] as? [[String: Any]] else {
                    onError(NSError(domain: "MultiplayerSession", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid session data."]))
                    return
                }
                print("Answers are updated: \(answers.count)")
                onUpdate(answers)
            }
            
            if lookingFor == LookingFor.forCurrentIndex{
                guard let snapshot = snapshot,
                      let sessionData = snapshot.data(),
                      let currentIndex = sessionData["currentQuestionIndex"] as? Int,
                      let previousQuestionIndex = sessionData["previousQuestionIndex"] as? Int else {
                    onError(NSError(domain: "MultiplayerSession", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid session data."]))
                    return
                }
                print("Question index is updated, current: \(currentIndex), previous:\(previousQuestionIndex)")
                onUpdate((currentIndex, previousQuestionIndex))
            }
        }
    }
    
    
    
    //    func stopObservingSession(){
    //        dbListener?.remove()
    //    }
    
    func startQuiz(for sessionId: String) async throws -> Bool{
        print("Starting game for session: \(sessionId)")
//        var isGameStarted : Bool = false
//        multiplayerSessionCollection.document(sessionId).updateData(["isGameStarted": true]) { error in
//            if let error = error {
//                print("Error starting game: \(error.localizedDescription)")
//            }else {
//                print("Game started successfully")
//                isGameStarted = true
//                print("Session: \(sessionId) is now active")
//            }
//        }
        
        do {
            try await multiplayerSessionCollection.document(sessionId).updateData(["isGameStarted": true])
            print("Game started successfully")
            return true
        } catch {
            print("Error starting game: \(error.localizedDescription)")
            throw error
        }
        
//        return isGameStarted
    }
    
    func endQuiz(for sessionId: String) -> Bool{
        var isGameEnded : Bool = false
        multiplayerSessionCollection.document(sessionId).updateData(["isGameEnded": true]) { error in
            if let error = error {
                print("Error starting game: \(error.localizedDescription)")
            }else {
                print("Game started successfully")
                isGameEnded = true
            }
        }
        return isGameEnded
    }
    
}

