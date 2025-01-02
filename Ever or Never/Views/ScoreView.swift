//
//  ScoreView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-15.
//

import SwiftUI

struct ScoreView: View {
    @StateObject var singlePlayerViwModel: SinglePlayerSessionViewModel
    @State private var navigateToModeSelection = false
    @State private var showSignInView: Bool = false
    var body: some View {
        NavigationStack{
            ZStack{
                ViewBackground()
                Image("Ellipse-min")
                    .resizable()
                    .scaledToFit()
                
                ZStack{
                    VStack{
                        HStack{
                            Text("Scoreboard")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.top, 50)
                        .padding(.horizontal, 20)
                        
                        ZStack{
                            
                            Image("Success")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width / 2)
                                .padding(20)
                            
                            
                            VStack{
                                
                                Text("Your Final Score")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .fontWeight(.bold)
                                    .padding(.top, 20)
                                
                                HStack{
                                    Text("\(singlePlayerViwModel.yesAnswerCount)")
                                        .font(.custom("", size: 65))
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    
                                    Text("/ \(singlePlayerViwModel.questions.count * 10)")
                                        .font(.title)
                                        .foregroundColor(.gray)
                                }
                                
                                
                            }.padding(.top, UIScreen.main.bounds.height / 3)
                        }
                        
                        
                        VStack(spacing:30){
                            Button {
                                navigateToModeSelection = true
                            } label: {
                                Text("New Game")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(height: 55)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                                    .cornerRadius(10)
                            }
                            
                        }
                        .padding(.top, 20)
                        .padding(30)
                    }
                }
                
            }
        }
        .navigationDestination(isPresented: $navigateToModeSelection, destination: {
            GameModeSelectionView(showSignInView: $showSignInView)
        })
        .alert(isPresented: $singlePlayerViwModel.sessionStatus.isError){
            Alert(
                title: Text("Something went wrong"),
                message: Text(singlePlayerViwModel.sessionStatus.errorDescription ?? "An unhandled error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear{
            singlePlayerViwModel.calculateScore()
            
            Task{
                await singlePlayerViwModel.completeGameSession()
            }
        }
        .onDisappear{
            singlePlayerViwModel.resetData();
        }
        .padding(0)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ScoreView(singlePlayerViwModel: SinglePlayerSessionViewModel())
}
