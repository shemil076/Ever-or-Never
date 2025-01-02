//
//  MultiplayerQuizEndView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-12-20.
//

import SwiftUI

struct MultiplayerQuizEndView: View {
    @State var navigateToScoreboard: Bool = false
    var body: some View {
        NavigationStack{
            ZStack{
                ViewBackground()
                    .ignoresSafeArea()
                
                VStack{
                    VStack{
                        Image("end-quiz")
                            .resizable()
                            .scaledToFit()
                    }.padding(20)
                        .padding(.top, UIScreen.main.bounds.height / 5)
                    
                    VStack{
                        Text("All the Questions are Done!")
                            .font(.title)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                        
                        
                        Text("Checkout the Scoreboard for the points")
                            .foregroundStyle(.white)
                            .padding(.top,5)
                    }
                    
                    VStack{
                        Button {
                            navigateToScoreboard = true
                        } label: {
                            Text("Continue")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                                .cornerRadius(10)
                        }.padding(20)
                            .padding(.top, UIScreen.main.bounds.height / 9)
                        
                    }
                    
                    
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $navigateToScoreboard) {
            MultiplayerScoreView()
        }
    }
}

#Preview {
    MultiplayerQuizEndView()
}
