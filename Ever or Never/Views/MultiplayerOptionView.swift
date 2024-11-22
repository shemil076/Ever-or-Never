//
//  MultiplayerOptionView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-20.
//

import SwiftUI

struct MultiplayerOptionView: View {
    
   
    @State private var sessionIdInput : String = ""
    @State private var isGameSessionReady = false
    var body: some View {
        VStack (spacing: 50){
            Text("Multiplayer")
                .font(.largeTitle)
            
            NavigationLink(destination: QuestionCountSelectionView(isMultiplePlayerMode: .constant(true))){
                Text("Multiplayer")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                
            }
            
            VStack{
                HStack{
                    Text("Join now ")
                    
                    TextField("Session Id", text: $sessionIdInput)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                }
                
                Button {
                    Task{
                        try await MultiplayerSessionViewModel.shared.joingGameSession(sessionId: sessionIdInput)
                        isGameSessionReady = true
                    }
                } label: {
                    Text("Start Quiz")
                }
                
                NavigationLink(
                    destination: MultiplayLobby(),
                    isActive: $isGameSessionReady
                ) {
                    EmptyView() // Keeps the link hidden but active when `isGameSessionReady` is true
                }
            }
        }
        .onAppear{
            Task{
                try await MultiplayerSessionViewModel.shared.loadCurrentUser()
            }
        }
        .padding()
    }
}

#Preview {
    MultiplayerOptionView()
}
