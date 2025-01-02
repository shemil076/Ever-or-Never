//
//  ContentView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-10-30.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var multiplaySessionViewModel = MultiplayerSessionViewModel.shared
    @StateObject var gameSessionManager =  GameSessionManager.shared
    @State private var showSignInView: Bool = false
    
    @State private var navigateToGameModeSelection: Bool = false
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        ZStack {
            NavigationStack {
                GameModeSelectionView(showSignInView: $showSignInView)
                    .onChange(of: scenePhase) {
                        handleScenePhaseChange(scenePhase)
                    }
            }
            
//            NavigationLink(isActive: $navigateToGameModeSelection) {
//                GameModeSelectionView(showSignInView: $showSignInView)
//            } label: {
//                EmptyView()
//            }

        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
            self.navigateToGameModeSelection = false
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }

    func handleScenePhaseChange(_ scenePhase: ScenePhase)  {
        guard gameSessionManager.isMultiplayerGame,
             let _ = gameSessionManager.sessionID,
              let _ = gameSessionManager.playerID else { return }

        switch scenePhase {
        case .active:
            print("Active")
            gameSessionManager.markActive()
            
        case .inactive:
            print("Inactive")
            gameSessionManager.markActive()
            
//            if multiplaySessionViewModel.isGameStarted && !multiplaySessionViewModel.isGameEnded{
//                Task{
//                    try? await Task.sleep(nanoseconds: 10_000_000_000)
//                    await multiplaySessionViewModel.removeQuitedPlayers()
//                    navigateToGameModeSelection = true
//                }
//            }
        case .background:
            print("Background")
        
        default:
            break
        }
    }
}


#Preview {
    ContentView()
}
