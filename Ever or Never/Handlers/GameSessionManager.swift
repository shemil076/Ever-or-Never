//
//  GameSessionManager.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-12-10.
//

import Foundation


class GameSessionManager : ObservableObject {
    @Published var testingString = "This is comming from game session manager"
    @Published var isMultiplayerGame: Bool = false
    @Published var sessionID: String? = nil
    @Published var playerID: String? = nil
    

    static var shared = GameSessionManager()
}
