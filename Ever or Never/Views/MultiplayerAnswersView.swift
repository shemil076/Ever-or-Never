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
    @State var navigateToEncView: Bool = false
    @State private var showNotAllAnsweredAlert: Bool = false
    @State private var isAllAnswered: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                ViewBackground()
                VStack(alignment: .leading, spacing: 20){
                    Text ("Submited Answers")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .accessibilityLabel("Submitted Answers heading")
                    
                    if !navigateToQuiz{
                        if (multiplaySessionViewModel.answers.isEmpty){
                            ProgressView()
                                .accessibilityLabel("Loading answers")
                        }else{
                            if multiplaySessionViewModel.questions.indices.contains(multiplaySessionViewModel.currentQuestionIndex){
                                
                                
                                VStack {
                                    
                                    
                                    //                                let currentQuestionIndex = multiplaySessionViewModel.questions.firstIndex(where: {$0.id == multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].id})
                                    
                                    let _ = multiplaySessionViewModel.questions.firstIndex(where: {$0.id == multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].id})
                                    
                                    if multiplaySessionViewModel.answers.indices.contains(multiplaySessionViewModel.currentQuestionIndex) {
                                        
                                        
                                        let currentAnswers = multiplaySessionViewModel.answers[multiplaySessionViewModel.currentQuestionIndex].answers
                                        
                                        ZStack{
                                            
                                            Rectangle()
                                                .fill(Color(red: 28/255, green: 41/255, blue: 56/255))
                                                .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 1.6)
                                                .cornerRadius(20)
                                                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 5)
                                            
                                            VStack{
                                                HStack{
                                                    Text ("\(multiplaySessionViewModel.currentQuestionIndex + 1) of \(multiplaySessionViewModel.questions.count) Questions")
                                                        .font(.subheadline)
                                                        .foregroundColor(.gray)
                                                        .accessibilityLabel("Question \(multiplaySessionViewModel.currentQuestionIndex + 1) of \(multiplaySessionViewModel.questions.count)")
                                                    Spacer()
                                                }
                                                .padding(.bottom, 10)
                                                
                                                Text ("\(multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].question)?")
                                                    .multilineTextAlignment(.leading)
                                                    .font(.title)
                                                    .foregroundColor(.white)
                                                    .accessibilityLabel("Question: \(multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].question)")
                                                
                                                
                                                
                                                
                                                
                                                //                                            ForEach(currentAnswers) { answer in
                                                ForEach(Array(currentAnswers.enumerated()), id: \.element.id) { index, answer in
                                                    
                                                    HStack(alignment: .center,spacing: UIScreen.main.bounds.width * 0.1 ) {
                                                        let playerIndex = multiplaySessionViewModel.participants.firstIndex(where: { $0.id == answer.playerId })
                                                        
                                                        Spacer()
                                                        
                                                        Text("\(index + 1)")
                                                            .foregroundColor(.white)
                                                        
                                                            .background(
                                                                Circle()
                                                                    .fill(Color(red: 28/255, green: 41/255, blue: 56/255))
                                                                    .frame(width: UIScreen.main.bounds .width * 0.1, height: UIScreen.main.bounds .width * 0.1)
                                                                    .overlay(content: {
                                                                        Circle()
                                                                            .stroke(Color.gray, lineWidth: 2)
                                                                    })
                                                            )
                                                        
                                                        Text(multiplaySessionViewModel.participants[playerIndex!].displayName)
                                                            .foregroundColor(.white)
                                                        //                                                            .accessibilityLabel("Player: \(multiplaySessionViewModel.participants[playerIndex].displayName)")
                                                        
                                                        
                                                        
                                                        Text(answer.answer ? "Yes" : "No")
                                                            .foregroundColor(.white)
                                                            .background(
                                                                Rectangle()
                                                                    .fill(answer.answer ? Color(red: 55 / 255, green: 89 / 255, blue: 139 / 255) :  Color(red: 48 / 255, green: 60 / 255, blue: 74 / 255))
                                                                    .frame(width: UIScreen.main.bounds .width / 5 , height: 40)
                                                                    .cornerRadius(15)
                                                            )
                                                            .accessibilityLabel("Answer: \(answer.answer ? "Yes" : "No")")
                                                        
                                                        Spacer()
                                                        //                                                    ZStack{
                                                        //
                                                        //
                                                        //
                                                        //                                                    }.background(
                                                        //                                                        Rectangle()
                                                        //                                                            .fill(.white)
                                                        //                                                            .frame(width: UIScreen.main.bounds .width / 2 , height: 50)
                                                        //                                                            .cornerRadius(15)
                                                        //                                                            .padding(.leading, UIScreen.main.bounds .width * 0.15)
                                                        //
                                                        //                                                    )
                                                        //                                                    .padding(.leading, 10)
                                                        
                                                        //                                                    ZStack{
                                                        //
                                                        //                                                    }.background(
                                                        //                                                        Rectangle()
                                                        //                                                            .fill(answer.answer ? Color(red: 78/255, green: 130/255, blue: 209/255) : .black)
                                                        //                                                            .frame(width: UIScreen.main.bounds .width / 4 , height: 50)
                                                        //                                                            .cornerRadius(15)
                                                        //                                                    )
                                                    }.background(
                                                        Rectangle()
                                                            .fill(Color(red: 28/255, green: 41/255, blue: 56/255))
                                                            .frame(height: 65)
                                                            .frame(maxWidth: .infinity)
                                                            .cornerRadius(15)
                                                        
                                                        
                                                    ).overlay(
                                                        RoundedRectangle(cornerRadius: 15)
                                                            .stroke(Color.gray, lineWidth: 1)
                                                            .frame(height: 65)
                                                            .frame(maxWidth: .infinity)
                                                    )
                                                    .padding(10)
                                                    .padding(.top, 20)
                                                }
                                                
                                            }.padding()
                                        }
                                        
                                        if multiplaySessionViewModel.hostId == multiplaySessionViewModel.user?.id{
                                            Button{
                                                
                                                if currentAnswers.count < multiplaySessionViewModel.activeParticipants.count{
                                                    showNotAllAnsweredAlert = true
                                                }else{
                                                    Task{
                                                        await multiplaySessionViewModel.updateQuestionIndexes()
                                                    }
                                                }
                                                
                                            } label: {
                                                Text("Continue")
                                                    .font(.headline)
                                                    .foregroundStyle(.white)
                                                    .frame(height: 55)
                                                    .frame(maxWidth: .infinity)
                                                    .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                                                    .cornerRadius(10)
                                            }
                                            .padding(.top, 20)
                                            //                                            .accessibilityLabel("Continue to the next question")
                                        }
                                        
                                        
                                        
                                    } else {
                                        Text("Waiting for players to submit answers...")
                                            .foregroundColor(.gray)
                                            .accessibilityLabel("Waiting for players to submit answers")
                                    }
                                    
                                    
                                }.padding(.horizontal, 20)
                                    .alert(isPresented: $showNotAllAnsweredAlert){
                                        Alert(
                                            title: Text("Wait.."),
                                            message: Text("Wait for all players to submit answers"),
                                            dismissButton: .default(Text("OK"), action: {
                                                showNotAllAnsweredAlert = false
                                            })
                                        )
                                    }
                                
                                
                                
                            }
                            
                        }
                    }
                    
                    
                    
                    
                    //                    NavigationLink(
                    //                        destination: MultiplayerQuizEndView(),
                    //                        isActive: $navigateToEncView,
                    //                        label: { EmptyView() }
                    //                    )
                    
                    
                    
                    
                }.padding()
                    .onAppear{
                        navigateToQuiz = false
                        multiplaySessionViewModel.observeSessionAnswers()
                        multiplaySessionViewModel.observeSessionForIndexesUpdate()
                        multiplaySessionViewModel.observeForParticipantsStatus()
                        multiplaySessionViewModel.observeForActiveParticipants()
                        
                        
                    }
                    .onDisappear(){
                        //            multiplaySessionViewModel.stopObservingSession()
                        isAllAnswered = false
                    }
                    .onChange(of: multiplaySessionViewModel.currentQuestionIndex) {
                        if multiplaySessionViewModel.previousQuestionIndex != multiplaySessionViewModel.currentQuestionIndex{
                            navigateToQuiz = true
                        }
                        if !multiplaySessionViewModel.questions.indices.contains(multiplaySessionViewModel.currentQuestionIndex) {
                            navigateToEncView       = true
                        }
                        
                    }
                    .background(
                        //                        NavigationLink(
                        //                            destination: MultiplayerQuizView(),
                        //                            isActive: $navigateToQuiz,
                        //                            label: { EmptyView() }
                        //                        )
                        
                        EmptyView()
                            .navigationDestination(isPresented: $navigateToQuiz, destination: {
                                MultiplayerQuizView()
                            })
                    )
            }
        }
        
        .navigationDestination(isPresented: $navigateToEncView, destination: {
            MultiplayerQuizEndView()
        })
        .navigationBarBackButtonHidden()
        //        .ignoresSafeArea()
    }
}

#Preview {
    MultiplayerAnswersView()
}

//Rectangle()
//    .fill(Color(red: 28/255, green: 41/255, blue: 56/255))
//    .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 1.5)
//    .cornerRadius(20)
//    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 5)
