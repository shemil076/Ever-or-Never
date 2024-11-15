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
                
                NavigationLink(destination: QuestionCountSelectionView()){
                    Text("Single Player")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                }
                
                Button("Multiplayer") {
                    // Placeholder for future multiplayer logic
                }
                .disabled(true) // Disable until multiplayer is implemented
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
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
