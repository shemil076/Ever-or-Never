//
//  ScoreView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-15.
//

import SwiftUI

struct ScoreView: View {
    @StateObject var singlePlayerViwModel: SinglePlayerSessionViewModel
    var body: some View {
        ZStack{
            ViewBackground()
            Image("Ellipse")
                .resizable()
                .scaledToFit()
            
            VStack{
                Spacer()
                HStack{
                    Text("Scoreboard")
                        .font(.title)
                    Spacer()
                }
                .padding(20)
                
                ZStack{
                    VStack{
                        Image("Success")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width / 3)
                            .padding(20)
                        
                        Text("Your Final Score")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .fontWeight(.bold)
                        
                        HStack{
                            Text("\(singlePlayerViwModel.yesAnswerCount)")
                                .font(.custom("", size: 65))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("/ \(singlePlayerViwModel.questions.count * 10)")
                                .font(.title)
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                    }
                }
                .background(
                    Rectangle()
                                        .fill(.white)
                                        .frame(width: UIScreen.main.bounds.width / 1.2)
                                        .cornerRadius(20)
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 5)
                )
                
                Spacer()
                
                VStack(spacing:30){
                    Button {

                    } label: {
                        Text("New Game")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                            .cornerRadius(10)
                    }
                    Button {

                    } label: {
                        Text("Quit")
                            .font(.headline)
                            .foregroundStyle(.black)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 10)
                .padding(30)
            }
            
            
           
           

        }
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
        .padding(0)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ScoreView(singlePlayerViwModel: SinglePlayerSessionViewModel())
//    ScoreView()
}
