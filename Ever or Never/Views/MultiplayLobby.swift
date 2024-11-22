//
//  MultiplayLobby.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-19.
//

import SwiftUI

struct MultiplayLobby: View {
    @StateObject private var multiplaySessionViewModel = MultiplayerSessionViewModel.shared
    @State private var navigateToQuiz = false

    var body: some View {
        VStack(spacing: 100) {
            VStack {
                Text("Session Id")
                    .font(.title)

                Text(multiplaySessionViewModel.currentSessionId ?? "id will be generated here")
                    .font(.title2)
                    .foregroundColor(.gray)
            }

            Section {
                Text("Players")
                    .font(.title2)

                // Displaying the list of participants
                List(multiplaySessionViewModel.participants) { participant in
                    VStack(alignment: .leading) {
                        Text(participant.displayName)
                            .font(.headline)
                        Text(participant.id)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            
            if multiplaySessionViewModel.hostId == multiplaySessionViewModel.user?.id {
                           Button(action: {
                               multiplaySessionViewModel.startQuiz()
                           }) {
                               Text("Continue")
                                   .font(.headline)
                                   .padding()
                                   .frame(maxWidth: .infinity)
                                   .background(Color.blue)
                                   .foregroundColor(.white)
                                   .cornerRadius(10)
                           }
                       }
        }
        .padding()
        .onAppear {
            print("sesionId: \(multiplaySessionViewModel.currentSessionId ?? "none")")
            if let sessionId = multiplaySessionViewModel.currentSessionId {
                multiplaySessionViewModel.observeParticipants(for: sessionId)
                multiplaySessionViewModel.observeSessionStates()
            }
        }
        .onDisappear {
            multiplaySessionViewModel.stopObservingParticipants()
            multiplaySessionViewModel.stopObservingSessionState()
        }
        .onChange(of: multiplaySessionViewModel.isGameStarted) { isGameStarted in
                   if isGameStarted {
                       navigateToQuiz = true // Trigger navigation
                   }
               }
               .background(
                   // Navigation Link triggered programmatically
                   NavigationLink(
                       destination: MultiplayerQuizView(),
                       isActive: $navigateToQuiz,
                       label: { EmptyView() }
                   )
               )
    }
}


#Preview {
    MultiplayLobby()
}
