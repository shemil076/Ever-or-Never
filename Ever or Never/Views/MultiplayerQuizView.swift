//
//  MultiplayerQuizView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-21.
//

import SwiftUI

struct MultiplayerQuizView: View {
    @StateObject private var multiplaySessionViewModel = MultiplayerSessionViewModel.shared
//    @State private var currentQuestionIndex: Int = 0
    @State private var showAnswer: Bool = false
    var body: some View {
        VStack {
            if !multiplaySessionViewModel.questions.isEmpty && multiplaySessionViewModel.currentQuestionIndex < multiplaySessionViewModel.questions.count {
                Text(multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].question)
                
                VStack{
                    Button("YES") {
                        if multiplaySessionViewModel.currentQuestionIndex < (multiplaySessionViewModel.questions.count ) {
                            
                           
                            
                            Task{
                                await multiplaySessionViewModel.submitAnswer(question: multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].question, questionId: multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].id, answer: true)
                                
                            }
                            showAnswer = true
//                            currentQuestionIndex += 1
                            
                        } else {
                            // End of quiz logic
                           
                            
                        }
                        
            
                    }
                    
                    Button("NO") {
                        if multiplaySessionViewModel.currentQuestionIndex < (multiplaySessionViewModel.questions.count) {
                            
                            
                            Task{
                                await    multiplaySessionViewModel.submitAnswer(question: multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].question, questionId: multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].id, answer: false)
                            }
                            
//                            currentQuestionIndex += 1
                            showAnswer = true
                        } else {
                            // End of quiz logic
                        }
                    }
                }
                
                NavigationLink(
                    destination: MultiplayerAnswersView(),
                    isActive: $showAnswer
                ){
                    EmptyView()
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


//
//Button {
//    Task{
//        try await MultiplayerSessionViewModel.shared.joingGameSession(sessionId: sessionIdInput)
//        isGameSessionReady = true
//    }
//} label: {
//    Text("Start Quiz")
//}
//
//NavigationLink(
//    destination: MultiplayLobby(),
//    isActive: $isGameSessionReady
//) {
//    EmptyView() // Keeps the link hidden but active when `isGameSessionReady` is true
//}
