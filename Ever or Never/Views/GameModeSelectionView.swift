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
                    
                    NavigationLink(destination: QuestionCountSelectionView(isMultiplePlayerMode: .constant(false))){
                        VStack{
                            ZStack{
                                HStack{
                                    Spacer()
                                
                                }
                                HStack{
                                    VStack(alignment: .leading){
                                        Text("Single player")
                                            .font(.title)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        
                                        Text("Solo gameplay experience.")
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
//                                    .fill(Color(red: 103/255, green: 134/255, blue: 236/255))
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: UIScreen.main.bounds .width * 0.9 , height: UIScreen.main.bounds.height * 0.16)
                                    .cornerRadius(15)
                            )
                            
                        }
                    
                        
                    }
                    
                    NavigationLink(destination: MultiplayerOptionView()){
                        VStack{
                            ZStack{
                                HStack{
                                    Spacer()
                                    
                                }
                                HStack{
                                    VStack(alignment: .leading){
                                        Text("Multiplayer")
                                            .font(.title)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        
                                        Text("Interactive group experience.")
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
//                                    .fill(Color(red: 78/255, green: 130/255, blue: 209/255))
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: UIScreen.main.bounds .width * 0.9 , height: UIScreen.main.bounds.height * 0.16)
                                    .cornerRadius(15)
                            )
                            
                        }
                    
                    }.padding()
                }
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
                            }
                        }
                    }
                
                
            }
        
//        .ignoresSafeArea()
        
        
    }
}

#Preview {
    GameModeSelectionView(showSignInView: .constant(false))
}
