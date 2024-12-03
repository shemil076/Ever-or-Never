//
//  SessionError.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-12-03.
//

import Foundation

struct SessionStatus : Codable{
    var isLoading: Bool
    var isError: Bool
    var errorDescription: String?
}
