//
//  SinglePlayerSessionManager.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-08.
//



import Foundation
import FirebaseFirestore

struct SinglePlayerQuizSession: Codable{
    var id: String
    let dateCreated: Date
    let userId: String
    let numberOfQuestions: Int
    let score: TypeScore
    let questionCategories: [QuestionCategory]
    let questionsAndAnswers: [QuestionAnswer]
    
    init(id: String = "", dateCreated: Date, userId: String, numberOfQuestions: Int, score: TypeScore, questionCategories: [QuestionCategory], questionsAndAnswers: [QuestionAnswer]) {
            self.id = id
            self.dateCreated = dateCreated
            self.userId = userId
            self.numberOfQuestions = numberOfQuestions
            self.score = score
            self.questionCategories = questionCategories
            self.questionsAndAnswers = questionsAndAnswers
        }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.numberOfQuestions = try container.decode(Int.self, forKey: .numberOfQuestions)
        self.score = try container.decode(TypeScore.self, forKey: .score)
        self.questionCategories = try container.decode([QuestionCategory].self, forKey: .questionCategories)
        self.questionsAndAnswers = try container.decode([QuestionAnswer].self, forKey: .questionsAndAnswers)
    }
    
    enum CodingKeys: String,  CodingKey {
        case id = "id"
        case dateCreated = "dateCreated"
        case userId = "userId"
        case numberOfQuestions = "numberOfQuestions"
        case score = "score"
        case questionCategories = "questionCategories"
        case questionsAndAnswers = "questionsAndAnswers"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.numberOfQuestions, forKey: .numberOfQuestions)
        try container.encode(self.score, forKey: .score)
        try container.encode(self.questionCategories, forKey: .questionCategories)
        try container.encode(self.questionsAndAnswers, forKey: .questionsAndAnswers)
    }
    
}

final class SinglePlayerSessionManager{
   
    
    init() {
        
    }
    
    private let singlePlayerSessionCollection = Firestore.firestore().collection("singlePlayerSession")
    
    private func singlePlayerDocument(quizSessionId: String) -> DocumentReference {
        singlePlayerSessionCollection.document(quizSessionId)
    }
    
    func createInitialQuizSession(userId: String, numberOfQuestions: Int, qustionCategories: [QuestionCategory]) async throws -> String?{
        
        print("userId: \(userId)")
        var newSession = SinglePlayerQuizSession(
            dateCreated: Date(),
            userId: userId,
            numberOfQuestions: numberOfQuestions,
            score: TypeScore(yesAnswerCount: 0, noAnswerCount: 0),
            questionCategories: qustionCategories,
            questionsAndAnswers:[]
        )
                
        var sessionID: String? = nil
        
        do {
            let data = try Firestore.Encoder().encode(newSession)
//            sessionRef = singlePlayerSectionsCollection.addDocument(data: data){ error in
//                if let error = error{
////                    throw URLError(.badServerResponse)
//                    print("Error adding document: \(error.localizedDescription)")
//                    return
//                }
//                
//                guard let sessionId = sessionRef?.documentID else {
////                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve session ID."])))
//                    print("Failed to retrieve session ID.")
//                    return
//                }
//                
//                sessionRef?.updateData(["quiz_session_id": sessionId]) { updatedError in
//                    if let updatedError {
////                        completion(.failure(updatedError))
//                        print("Error updating document: \(updatedError.localizedDescription)")
//                        return
//                    }else{
//                        newSession.quizSessionId = sessionId
//                        print("Session created successfully.")
//                        
//                        sessionID = sessionId
//                        
////                        completion(.success(newSession))
//                    }
//                }
//                
//            }
            
            
            
            let documentRef = try await singlePlayerSessionCollection.addDocument(data: data)
            sessionID = documentRef.documentID
            
            try await documentRef.updateData(["id": sessionID!])
            
            newSession.id = sessionID!
            print("Session created successfully with ID: \(sessionID!)")
            
            
            return sessionID
            
            
        } catch {
//            completion(.failure(error))
            print("Error creating initial quiz session: \(error.localizedDescription)")
            return sessionID
            
        }
    }
    
    
    func completeSessionByUpdatingData(sessionId : String, score : TypeScore , questionsAnswers : [QuestionAnswer]) async throws{
        
        let data: [String: Any] = [
                "score": [
                    "yesAnswerCount": score.yesAnswerCount,
                    "noAnswerCount": score.noAnswerCount
                ],
                "questionsAndAnswers": questionsAnswers.map { questionAnswer in
                    [
                        "questionId": questionAnswer.question,
                        "answer": questionAnswer.answer
                    ]
                },
                "dateCompleted": FieldValue.serverTimestamp()
            ]
        
        
        let documentRef = singlePlayerSessionCollection.document(sessionId)
           
           do {
               // Update the document in Firestore
               try await documentRef.updateData(data)
               print("Session \(sessionId) updated successfully.")
           } catch {
               print("Failed to update session \(sessionId): \(error.localizedDescription)")
               throw error
           }
    }
    

    func fetchSessionData(sessionId: String) async throws -> SinglePlayerQuizSession?{
        let documentRef = try await singlePlayerSessionCollection.document(sessionId).getDocument()
        
        guard let documentData = documentRef.data() else {
            print("No data related to session Id \(sessionId) was found")
            throw NSError(domain: "MultiplayerSession", code: -1, userInfo: [NSLocalizedDescriptionKey: "Session not found."])
        }
        
        do {
            let session = try Firestore.Decoder().decode(SinglePlayerQuizSession.self, from: documentData)
            return session
        }catch{
            print("Decoding error: \(error)")
            throw NSError(domain: "MultiplayerSession", code: -2, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(error.localizedDescription)"])
        }
    }
    
}


//func fetchSession(sessionId: String) async throws -> MultiplayerQuizSession {
//    let document = try await multiplayerSessionCollection.document(sessionId).getDocument()

//    
//    guard let data = document.data() else {
//        print("No data related to session Id \(sessionId) was found")
//        throw NSError(domain: "MultiplayerSession", code: -1, userInfo: [NSLocalizedDescriptionKey: "Session not found."])
//    }

//    
//    do {
//        // Attempt to decode the session data
//        let session = try Firestore.Decoder().decode(MultiplayerQuizSession.self, from: data)
//        return session
//    } catch {
//        // Catch and print the decoding error
//        print("Decoding error: \(error)")
//        throw NSError(domain: "MultiplayerSession", code: -2, userInfo: [NSLocalizedDescriptionKey: "Decoding error: \(error.localizedDescription)"])
//    }
//}
