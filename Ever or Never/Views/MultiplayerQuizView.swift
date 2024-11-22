//
//  MultiplayerQuizView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-21.
//

import SwiftUI

struct MultiplayerQuizView: View {
    @StateObject private var multiplaySessionViewModel = MultiplayerSessionViewModel.shared
    @State private var currentQuestionIndex: Int = 0
    var body: some View {
        VStack {
            if !multiplaySessionViewModel.questions.isEmpty && currentQuestionIndex < multiplaySessionViewModel.questions.count {
                Text(multiplaySessionViewModel.questions[currentQuestionIndex].question)
                
                VStack{
                    Button("YES") {
                        if currentQuestionIndex < (multiplaySessionViewModel.questions.count ) {
                            
                           
                            
                            Task{
                                await multiplaySessionViewModel.submitAnswer(question: multiplaySessionViewModel.questions[currentQuestionIndex].question, questionId: multiplaySessionViewModel.questions[currentQuestionIndex].id, answer: true)
                                
                            }
                            currentQuestionIndex += 1
                            
                        } else {
                            // End of quiz logic
                           
                            
                        }
                        
            
                    }
                    
                    Button("NO") {
                        if currentQuestionIndex < (multiplaySessionViewModel.questions.count) {
                            
                            
                            Task{
                                await    multiplaySessionViewModel.submitAnswer(question: multiplaySessionViewModel.questions[currentQuestionIndex].question, questionId: multiplaySessionViewModel.questions[currentQuestionIndex].id, answer: false)
                            }
                            
                            currentQuestionIndex += 1
                        } else {
                            // End of quiz logic
                        }
                    }
                }
            }else{
                
//                ScoreView(singlePlayerViwModel: singlePlayerViwModel)
            }
        }
        .padding()
    }
}

#Preview {
    MultiplayerQuizView()
}
