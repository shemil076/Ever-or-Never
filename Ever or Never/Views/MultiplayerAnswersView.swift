//
//  MultiplayerAnswersView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-22.
//

import SwiftUI

struct MultiplayerAnswersView: View {
    @StateObject private var multiplaySessionViewModel = MultiplayerSessionViewModel.shared
    @State var navigateToQuiz: Bool = false
    @State var navigateToScoreboard: Bool = false
    var body: some View {
        ZStack{
            ViewBackground()
            VStack{
                Text ("Submited Answers")
                    .font(.largeTitle)
                
                if !navigateToQuiz{
                    if (multiplaySessionViewModel.answers.isEmpty){
                        ProgressView()
                    }else{
                        if multiplaySessionViewModel.questions.indices.contains(multiplaySessionViewModel.currentQuestionIndex){
                            Text ("\(multiplaySessionViewModel.currentQuestionIndex + 1) of \(multiplaySessionViewModel.questions.count) questions")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text ("\(multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].question)")
                            VStack(alignment: .center) {
                                let currentQuestionIndex = multiplaySessionViewModel.questions.firstIndex(where: {$0.id == multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].id})
                                
                                if multiplaySessionViewModel.answers.indices.contains(multiplaySessionViewModel.currentQuestionIndex) {
                                    let currentAnswers = multiplaySessionViewModel.answers[multiplaySessionViewModel.currentQuestionIndex].answers
                                    
                                    ForEach(currentAnswers) { answer in
                                        HStack(spacing: UIScreen.main.bounds.width * 0.4) {
                                    
                                            let playerIndex = multiplaySessionViewModel.participants.firstIndex(where: { $0.id == answer.playerId })
                                            Text(multiplaySessionViewModel.participants[playerIndex!].displayName)
                                                .background(
                                                    Rectangle()
                                                        .fill(.white)
                                                        .frame(width: UIScreen.main.bounds .width * 0.6 , height: UIScreen.main.bounds.height * 0.07)
                                                        .cornerRadius(15)
                                                    
                                                )
                                            Text(answer.answer ? "Yes" : "No")
                                                .foregroundColor(.white)
                                                .background(
                                                    Rectangle()
                                                        .fill(answer.answer ? Color(red: 78/255, green: 130/255, blue: 209/255) : .black)
                                                        .frame(width: UIScreen.main.bounds .width * 0.2 , height: UIScreen.main.bounds.height * 0.07)
                                                        .cornerRadius(15)
                                                )
                                        }
                                        .padding()
                                    }
                                } else {
                                    Text("Waiting for players to submit answers...")
                                        .foregroundColor(.gray)
                                }
                                
                                
                            }.padding(.horizontal, 20)
                        }
    //                    else{
    //                        // When there are no more questions, navigate to the quiz screen
    //                        Text("No more questions. Navigating...")
    //                               .onAppear {
    //                                   navigateToScoreboard = true
    //                               }
    //                    }
                    }
                }
                
                
                if multiplaySessionViewModel.hostId == multiplaySessionViewModel.user?.id{
                    Button{
    //                    if multiplaySessionViewModel.currentQuestionIndex <= multiplaySessionViewModel.questions.count {
    //                        navigateToQuiz = true
    //                    }else{
    //                        navigateToScoreboard = true
    //                    }
                        
                        Task{
                            try? await multiplaySessionViewModel.updateQuestionIndexes()
                        }
                    } label: {
                        Text("Continue")
                    }
                }
                
                NavigationLink(
                    destination: MultiplayerScoreView(),
                    isActive: $navigateToScoreboard,
                    label: { EmptyView() }
                )
                
                
                
                
            }.ignoresSafeArea()
            .onAppear{
                navigateToQuiz = false
                multiplaySessionViewModel.observeSessionAnswers()
                multiplaySessionViewModel.observeSessionForIndexesUpdate()
            }
            .onDisappear(){
    //            multiplaySessionViewModel.stopObservingSession()
            }
            .onChange(of: multiplaySessionViewModel.currentQuestionIndex) { currentQuestionIndex in
                if multiplaySessionViewModel.previousQuestionIndex != currentQuestionIndex{
                    navigateToQuiz = true
                }
                if !multiplaySessionViewModel.questions.indices.contains(multiplaySessionViewModel.currentQuestionIndex) {
                    navigateToScoreboard = true
                }
                
            }
            .background(
                NavigationLink(
                    destination: MultiplayerQuizView(),
                    isActive: $navigateToQuiz,
                    label: { EmptyView() }
                )
            )
        }
    }
}

#Preview {
    MultiplayerAnswersView()
}

