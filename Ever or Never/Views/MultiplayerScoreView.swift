//
//  MultiplayerScoreView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-25.
//

import SwiftUI

struct MultiplayerScoreView: View {
    @StateObject private var multiplaySessionViewModel = MultiplayerSessionViewModel.shared
    var body: some View {
        VStack{
            Text("Score View")
            List(multiplaySessionViewModel.score.sorted(by: { $0.key < $1.key }), id: \.key) { playerId, score in
                HStack {
                    Text("Player ID: \(playerId)")
                        .font(.body)
                    Spacer()
                    Text("Score: \(score)")
                        .font(.headline)
                }
                .padding(.vertical, 5)
                
            }
        }.onAppear {
            print("Multiplayer Score View Appeared")
            multiplaySessionViewModel.calculateScores()
        }
        .onDisappear(){
            multiplaySessionViewModel.stopObservingSession()
        }
    }
}

#Preview {
    MultiplayerScoreView()
}
