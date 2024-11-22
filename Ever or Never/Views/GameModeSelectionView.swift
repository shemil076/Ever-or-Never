//
//  GameModeSelectionView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-12.
//

import SwiftUI

struct GameModeSelectionView: View {
    @StateObject var profileViewModel = ProfileViewModel()
    @Binding var showSignInView : Bool
    var body: some View {
        NavigationView{
            VStack(spacing : 20){
                Text("Selecting Game Mode")
                    .font(.title)
                    .padding()
                
                NavigationLink(destination: QuestionCountSelectionView(isMultiplePlayerMode: .constant(false))){
                    Text("Single Player")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                }
                
                NavigationLink(destination: MultiplayerOptionView()){
                    Text("Multiplayer")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                }
            }
            .task{
                try? await profileViewModel.loadCurrentUser()
            }
            .navigationTitle("Profile")
                .toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        
                        NavigationLink{
                            SettingsView(showSignInView: $showSignInView)
                        } label: {
                            Image(systemName: "gear")
                                .font(.headline)
                        }
                    }
                }
            .padding()
        }
    }
}

#Preview {
    GameModeSelectionView(showSignInView: .constant(false))
}
