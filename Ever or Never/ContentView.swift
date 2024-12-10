//
//  ContentView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-10-30.
//

import SwiftUI

struct ContentView: View {
    @StateObject var gameSessionManager =  GameSessionManager.shared
    @State private var showSignInView: Bool = false
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        ZStack {
            NavigationStack {
                GameModeSelectionView(showSignInView: $showSignInView)
                    .onChange(of: scenePhase) { newValue in
                        handleScenePhaseChange(newValue)
                    }
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }

    func handleScenePhaseChange(_ scenePhase: ScenePhase) {
        guard gameSessionManager.isMultiplayerGame,
              let sessionID = gameSessionManager.sessionID,
              let playerID = gameSessionManager.playerID else { return }

        switch scenePhase {
        case .active:
            print("Active")
        case .inactive:
            print("Inactive")
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
