//
//  UserHelperFunctions.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-12-09.
//

import Foundation

class UserHelperFunctions {
    
    static func updateSeenQuestions(userId : String, userSeenQuestions : Set<String>, questions : [Question]) async throws {
        let extractedQuestionIds = questions.reduce(into: [String]()){ result, item in
            result.append(item.id)
        }
        
        let _ = try await UserManager.shared.saveSeenQuestions(id: userId, seenQuestions: userSeenQuestions, newQuestions: Set(extractedQuestionIds))
    }
}
