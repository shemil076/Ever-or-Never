//
//  GameSessionView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-12.
//

import SwiftUI

struct GameSessionView: View {
    
    @StateObject var singlePlayerViwModel: SinglePlayerSessionViewModel
    @State private var currentQuestionIndex: Int = 0
    @State private var  navigateToScoreView = false
    var body: some View {
        ZStack {
            ViewBackground()
            
            ZStack{
                Rectangle()
                    .fill(Color(red: 187 / 255.0, green: 209 / 255.0, blue: 243 / 255.0))
                    .frame(width: UIScreen.main.bounds.width / 1.37, height: UIScreen.main.bounds.height / 1.5)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 5)
                    .offset(y: 20)
                Rectangle()
                    .fill(Color(red: 212 / 255.0, green: 227 / 255.0, blue: 249 / 255.0))
                    .frame(width: UIScreen.main.bounds.width / 1.27, height: UIScreen.main.bounds.height / 1.5)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 5)
                    .offset(y: 10)
                Rectangle()
                    .fill(.white)
                    .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 1.5)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 5)
                
                VStack(spacing: 50) {
                    HStack{
                        Text("Select an answer")
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(20)
                    
                    
                    if !singlePlayerViwModel.questions.isEmpty && currentQuestionIndex < singlePlayerViwModel.questions.count {
                        Text(singlePlayerViwModel.questions[currentQuestionIndex].question)
                            .multilineTextAlignment(.leading)
                            .font(.title)
                        
                        VStack(spacing:20){
                            
                            Button {
                                if currentQuestionIndex < (singlePlayerViwModel.questions.count ) {
                                    
                                   
                                    
                                    singlePlayerViwModel.submitAnswer(questionId: singlePlayerViwModel.questions[currentQuestionIndex].question, answer: true)
                                    
                                    currentQuestionIndex += 1
                                    
                                    if currentQuestionIndex == singlePlayerViwModel.questions.count {
                                        navigateToScoreView = true                                    }
                                    
                                } else {
                                    // End of quiz logic
                                   
                                }
                                
                    
                            } label: {
                                Text("Yes")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(height: 60)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                                    .cornerRadius(20)
                            }

                            
//                            Button("YES") {
//                                if currentQuestionIndex < (singlePlayerViwModel.questions.count ) {
//                                    
//                                   
//                                    
//                                    singlePlayerViwModel.submitAnswer(questionId: singlePlayerViwModel.questions[currentQuestionIndex].question, answer: true)
//                                    
//                                    currentQuestionIndex += 1
//                                    
//                                } else {
//                                    // End of quiz logic
//                                   
//                                    
//                                }
//                                
//                    
//                            }
                            
                            Button  {
                                if currentQuestionIndex < (singlePlayerViwModel.questions.count) {
                                    
                                    
                                    singlePlayerViwModel.submitAnswer(questionId: singlePlayerViwModel.questions[currentQuestionIndex].question, answer: false)
                                    
                                    currentQuestionIndex += 1
                                    if currentQuestionIndex == singlePlayerViwModel.questions.count {
                                        navigateToScoreView = true                                    }
                                } else {
                                }
                            } label: {
                                Text("NO")
                                    .font(.headline)
                                    .foregroundStyle(.black)
                                    .frame(height: 60)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 237 / 255.0, green: 239 / 255.0, blue: 240 / 255.0))
                                    .cornerRadius(20)
                            }

                            
//                            Button("NO") {
//                                if currentQuestionIndex < (singlePlayerViwModel.questions.count) {
//                                    
//                                    
//                                    singlePlayerViwModel.submitAnswer(questionId: singlePlayerViwModel.questions[currentQuestionIndex].question, answer: false)
//                                    
//                                    currentQuestionIndex += 1
//                                } else {
//                                    // End of quiz logic
//                                }
//                            }
                        }
                        .padding(20)
                        
                        Text("\(currentQuestionIndex + 1) of \(singlePlayerViwModel.questions.count) Questions")
                            .foregroundColor(.gray)
                    }
                        
//                    else{
//
//                        EmptyView()
//                            .onAppear{
//                                navigateToScoreView = true
//                            }
//                        ScoreView(singlePlayerViwModel: singlePlayerViwModel)
//
//                    }
                }
                .padding(20)
            }
            .padding(20)
            
            
            NavigationLink(destination: ScoreView(singlePlayerViwModel: singlePlayerViwModel), isActive: $navigateToScoreView) {
                EmptyView()
            }
        }
        .navigationBarBackButtonHidden()
    }
    
}

#Preview {
    
    GameSessionView(singlePlayerViwModel: SinglePlayerSessionViewModel())
}
