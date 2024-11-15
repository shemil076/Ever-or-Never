//
//  SinglePlayerSessionManager.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-08.
//



import Foundation
import FirebaseFirestore

struct SinglePlayerQuizSession: Codable{
    var quizSessionId: String
    let dateCreated: Date
    let userId: String
    let numberOfQuestions: Int
    let score: TypeScore
    let questionCategories: [QuestionCategory]
    let questionsAndAnswers: [QuestionAnswer]
    
    init(quizSessionId: String = "", dateCreated: Date, userId: String, numberOfQuestions: Int, score: TypeScore, questionCategories: [QuestionCategory], questionsAndAnswers: [QuestionAnswer]) {
            self.quizSessionId = quizSessionId
            self.dateCreated = dateCreated
            self.userId = userId
            self.numberOfQuestions = numberOfQuestions
            self.score = score
            self.questionCategories = questionCategories
            self.questionsAndAnswers = questionsAndAnswers
        }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.quizSessionId = try container.decode(String.self, forKey: .quizSessionId)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.numberOfQuestions = try container.decode(Int.self, forKey: .numberOfQuestions)
        self.score = try container.decode(TypeScore.self, forKey: .score)
        self.questionCategories = try container.decode([QuestionCategory].self, forKey: .questionCategories)
        self.questionsAndAnswers = try container.decode([QuestionAnswer].self, forKey: .questionsAndAnswers)
    }
    
    enum CodingKeys: String,  CodingKey {
        case quizSessionId = "quiz_session_id"
        case dateCreated = "date_created"
        case userId = "user_id"
        case numberOfQuestions = "number_of_questions"
        case score = "score"
        case questionCategories = "question_categories"
        case questionsAndAnswers = "questions_Answers"
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.quizSessionId, forKey: .quizSessionId)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.userId, forKey: .userId)
        try container.encode(self.numberOfQuestions, forKey: .numberOfQuestions)
        try container.encode(self.score, forKey: .score)
        try container.encode(self.questionCategories, forKey: .questionCategories)
        try container.encode(self.questionsAndAnswers, forKey: .questionsAndAnswers)
    }
}

final class SinglePlayerSessionManager{
    static let shared = SinglePlayerSessionManager()
    
    private init() {
        
    }
    
    private let singlePlayerSectionsCollection = Firestore.firestore().collection("singlePlayerSections")
    
    private func singlePlayerDocument(quizSessionId: String) -> DocumentReference {
        singlePlayerSectionsCollection.document(quizSessionId)
    }
    
    func createInitialQuizSession(userId: String, numberOfQuestions: Int, qustionCategories: [QuestionCategory]) async throws -> String?{
        var newSession = SinglePlayerQuizSession(
            dateCreated: Date(),
            userId: userId,
            numberOfQuestions: numberOfQuestions,
            score: TypeScore(yesAnswerCount: 0, noAnswerCount: 0),
            questionCategories: qustionCategories,
            questionsAndAnswers:[]
        )
        
        var sessionRef: DocumentReference? = nil
        
        var sessionID: String? = nil
        
        do {
            let data = try Firestore.Encoder().encode(newSession)
            sessionRef = singlePlayerSectionsCollection.addDocument(data: data){ error in
                if let error = error{
//                    throw URLError(.badServerResponse)
                    print("Error adding document: \(error.localizedDescription)")
                    return
                }
                
                guard let sessionId = sessionRef?.documentID else {
//                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve session ID."])))
                    print("Failed to retrieve session ID.")
                    return
                }
                
                sessionRef?.updateData(["quiz_session_id": sessionId]) { updatedError in
                    if let updatedError {
//                        completion(.failure(updatedError))
                        print("Error updating document: \(updatedError.localizedDescription)")
                        return
                    }else{
                        newSession.quizSessionId = sessionId
                        print("Session created successfully.")
                        
                        sessionID = sessionId
                        
//                        completion(.success(newSession))
                    }
                }
                
            }
            return sessionID
            
            
        } catch {
//            completion(.failure(error))
            print("Error creating initial quiz session: \(error.localizedDescription)")
            return sessionID
            
        }
    }
    
    
    
}


//let userId: String
//let dateCreated: Date?
//let email: String?
//let photoURL: String?
//let isPremium: Bool
//let displayName: String
//let dob : Date
