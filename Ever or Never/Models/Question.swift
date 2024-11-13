//
//  Question.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-08.
//

import Foundation

enum QuestionCategory: String, Codable {
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
