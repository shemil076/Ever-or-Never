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
    
    @Published private var multiplayerSessionManager = MultiplayerSessionManager()
    
    
    static var shared = GameSessionManager()
    
    func markActive(){
        guard let sessionID, let playerID else { return }
        
        multiplayerSessionManager.trackUserConnection(sessionId: sessionID, playerId: playerID)
        
    }
}
