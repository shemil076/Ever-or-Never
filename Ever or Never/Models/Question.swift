//
//  Question.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-08.
//

import Foundation

enum QuestionCategory: String, Codable, CaseIterable {
    case general = "General"
    case travel = "Travel"
    case school = "School"
    case relationships = "Relationships"
    case food = "Food"
    case adventure = "Adventure"
    case social = "Social"
    case music = "Music"
    case entertainment = "Entertainment"
    case health = "Health"
    case supernatural = "Supernatural"
    case personal = "Personal"
    case games = "Games"
    
    // Make the decoding case-insensitive
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self).lowercased()
        print("Decoded category: \(value)")  // Debugging line
        
        // Attempt to match with the enum cases
        self = QuestionCategory(rawValue: value.capitalized) ?? .general
        
        print("done decodeing")
    }
}

struct CodableQuestion: Codable{
    let question: String
    let category: QuestionCategory
    let suitableForAbove: Int
}


struct Question:Identifiable, Codable{
    let question: String
    let id: String
    let category: QuestionCategory
    let suitableForAbove: Int
    
}


struct QuestionAnswer: Identifiable , Codable {
    var id = UUID()  // Unique identifier for each instance
    var question: String
    var answer: Bool
}

struct TypeScore: Codable{
    let yesAnswerCount : Int
    let noAnswerCount : Int
}


//struct MultiplayerAnswer: Identifiable, Codable, Equatable{
//    var id = UUID()
//    let playerId: String
//    let answer: Bool
//    let createdAt: Date
//}


struct MultiplayerAnswer: Identifiable, Codable, Equatable {
    var id = UUID()
    let playerId: String
    let answer: Bool
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case playerId
        case answer
        case createdAt
    }
    
    init(id: UUID = UUID(), playerId: String, answer: Bool, createdAt: Date) {
        self.id = id
        self.playerId = playerId
        self.answer = answer
        self.createdAt = createdAt
    }
    
    // Custom initializer for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID(uuidString: try container.decode(String.self, forKey: .id)) ?? UUID()
        self.playerId = try container.decode(String.self, forKey: .playerId)
        self.answer = try container.decode(Bool.self, forKey: .answer)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
    }
    
    // Custom encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id.uuidString, forKey: .id)
        try container.encode(playerId, forKey: .playerId)
        try container.encode(answer, forKey: .answer)
        try container.encode(self.createdAt, forKey: .createdAt)
        
        // Encode `createdAt` as timestamp
//        try container.encode(createdAt.timeIntervalSince1970, forKey: .createdAt)
       
    }
}

struct MultiplayerQuestionAnswer : Identifiable, Codable, Equatable{
    var id : String
    var question: String
    var answers: [MultiplayerAnswer]
}
