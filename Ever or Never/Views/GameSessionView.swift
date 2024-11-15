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
    var body: some View {
        VStack {
            if !singlePlayerViwModel.questions.isEmpty && currentQuestionIndex < singlePlayerViwModel.questions.count {
                Text(singlePlayerViwModel.questions[currentQuestionIndex].question)
                
                VStack{
                    Button("YES") {
                        if currentQuestionIndex < (singlePlayerViwModel.questions.count ) {
                            
                           
                            
                            singlePlayerViwModel.submitAnswer(questionId: singlePlayerViwModel.questions[currentQuestionIndex].question, answer: true)
                            
                            currentQuestionIndex += 1
                            
                        } else {
                            // End of quiz logic
                           
                            
                        }
                        
            
                    }
                    
                    Button("NO") {
                        if currentQuestionIndex < (singlePlayerViwModel.questions.count) {
                            
                            
                            singlePlayerViwModel.submitAnswer(questionId: singlePlayerViwModel.questions[currentQuestionIndex].question, answer: false)
                            
                            currentQuestionIndex += 1
                        } else {
                            // End of quiz logic
                        }
                    }
                }
            }else{
                
                ScoreView(singlePlayerViwModel: singlePlayerViwModel)
            }
        }
        .padding()
    }
    
}

#Preview {
    
    GameSessionView(singlePlayerViwModel: SinglePlayerSessionViewModel())
}
