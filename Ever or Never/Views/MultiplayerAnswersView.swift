//
//  MultiplayerAnswersView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-22.
//

import SwiftUI

struct MultiplayerAnswersView: View {
    @StateObject private var multiplaySessionViewModel = MultiplayerSessionViewModel.shared
//    @State var showAnswers: Bool = false
    var body: some View {
        VStack{
            Text ("Submited Answers")
                .font(.largeTitle)
            
            
            Text ("\(multiplaySessionViewModel.currentQuestionIndex + 1) of \(multiplaySessionViewModel.questions.count) questions")
                .font(.caption)
                .foregroundColor(.gray)
            
            Text ("\(multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].question)")
            
            
            
            
            
            
            if (multiplaySessionViewModel.answers.isEmpty){
                ProgressView()
            }else{
                List {
                    let currentQuestionIndex = multiplaySessionViewModel.questions.firstIndex(where: {$0.id == multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].id})
                    
                    if currentQuestionIndex != nil {
                        ForEach(multiplaySessionViewModel.answers[currentQuestionIndex!].answers){ answer  in
                            HStack{
                                
                                let playerIndex = multiplaySessionViewModel.participants.firstIndex(where: {$0.id == answer.playerId})
                                
                                Text(multiplaySessionViewModel.participants[playerIndex!].displayName)
                                Spacer()
                                Text(answer.answer ? "Yes" : "No")
                            }
                            .padding()
                        }
                    }
                }
            }
            
            
            
            Button{
                
            } label: {
                Text("Continue")
            }
            
            
            
            
        }.onAppear{
            multiplaySessionViewModel.observeSessionAnswers()
        }
        .onDisappear(){
            multiplaySessionViewModel.stopObservingSession()
        }
    }
}

#Preview {
    MultiplayerAnswersView()
}

