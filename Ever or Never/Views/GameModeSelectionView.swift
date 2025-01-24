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
        
        ZStack{
            ViewBackground()
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing : UIScreen.main.bounds.height * 0.1){
                HStack(alignment: .firstTextBaseline){
                    Text("Select the Mode")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .padding()
                    Spacer()
                }
                
                ModeSelectionCard(
                    title: "Single Player",
                    description: "Solo gameplay experience.",
                    destination: QuestionCountSelectionView(isMultiplePlayerMode: .constant(false))
                )
                
                ModeSelectionCard(
                    title: "Multiplayer",
                    description: "Interactive group experience.",
                    destination: MultiplayerOptionView()
                )            }
            .padding()
            .task{
                try? await profileViewModel.loadCurrentUser()
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    NavigationLink{
                        SettingsView(showSignInView: $showSignInView)
                    } label: {
                        Image(systemName: "gear")
                            .font(.headline)
                            .accessibilityLabel("Settings")
                            .accessibilityHint("Open app settings")
                    }
                }
            }
            
            
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    GameModeSelectionView(showSignInView: .constant(false))
}


struct ModeSelectionCard<Destination: View>: View {
    let title : String
    let description : String
    let destination : Destination
    
    var body: some View {
        NavigationLink(destination:destination){
            VStack{
                ZStack{
                    HStack{
                        Spacer()
                        
                    }
                    HStack{
                        VStack(alignment: .leading){
                            Text(title)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            
                            Text(description)
                                .foregroundColor(.white)
                        }.padding()
                            .frame(width: UIScreen.main.bounds.width * 0.7)
                        
                        Image(systemName: "arrow.up.forward")
                            .foregroundColor(.black)
                            .background(
                                Rectangle()
                                    .fill(Color.white)
                                    .frame(width: UIScreen.main.bounds .width * 0.1, height: UIScreen.main.bounds .width * 0.1)
                                    .cornerRadius(50)
                            )
                            .padding(.top, 40)
                    }
                    
                }.background(
                    Rectangle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: UIScreen.main.bounds .width * 0.9 , height: UIScreen.main.bounds.height * 0.16)
                        .cornerRadius(15)
                )
                .padding(.horizontal, 20)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(title). \(description)")
                
            }
        }
    }
}
