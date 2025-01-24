//
//  MultiplayerQuizView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-21.
//

import SwiftUI

struct MultiplayerQuizView: View {
    @StateObject private var multiplaySessionViewModel = MultiplayerSessionViewModel.shared
    @State private var showAnswer: Bool = false
    @State private var showAlert : Bool = false
    var body: some View {
        NavigationStack{
            ZStack{
                ViewBackground()
                
                ZStack{
                    
                    Rectangle()
                        .fill(Color(red: 28/255, green: 41/255, blue: 56/255))
                        .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 1.4)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 5)
                    
                    VStack {
                        
                        if !multiplaySessionViewModel.questions.isEmpty && multiplaySessionViewModel.currentQuestionIndex < multiplaySessionViewModel.questions.count {
                            
                            let progress = CGFloat(multiplaySessionViewModel.currentQuestionIndex + 1) / CGFloat(multiplaySessionViewModel.questions.count)
                            
                            
                            HStack(alignment:.center){
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .frame( height: 10)
                                        .cornerRadius(10)
                                        .foregroundColor(Color.gray.opacity(0.3))
                                    
                                    Rectangle()
                                        .frame(width: progress * UIScreen.main.bounds.width / 2, height: 10)
                                        .cornerRadius(10)
                                        .foregroundColor(.blue)
                                        .animation(.easeInOut, value: progress)
                                        .accessibilityValue("\(Int(progress * 100))% completed")
                                }
                                .frame(width: UIScreen.main.bounds.width / 2)
                                
                                Text(" \(multiplaySessionViewModel.currentQuestionIndex + 1) / \(multiplaySessionViewModel.questions.count) ")
                                    .foregroundStyle(.white)
                                    .accessibilityLabel("Question \(multiplaySessionViewModel.currentQuestionIndex + 1) of \(multiplaySessionViewModel.questions.count)")
                            }
                            
                            HStack{
                                Text("Select an answer")
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.gray)
                                    .fontWeight(.semibold)
                                    .accessibilityLabel("Prompt to select an answer for the question")
                                Spacer()
                            }
                            .padding(20)
                            
                            Text(multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].question)
                                .multilineTextAlignment(.leading)
                                .font(.title)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .accessibilityLabel("Question: \(multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].question)")
                            
                            VStack(spacing: 30){
                                Button {
                                    if multiplaySessionViewModel.currentQuestionIndex < (multiplaySessionViewModel.questions.count ) {
                                        
                                        
                                        
                                        Task{
                                            await multiplaySessionViewModel.submitAnswer(question: multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].question, questionId: multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].id, answer: true)
                                            
                                            
                                            if multiplaySessionViewModel.sessionStatus.isError{
                                                showAlert = true
                                            }
                                        }
                                        showAnswer = true
                                        
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
                                .accessibilityLabel("Yes button")
                                .accessibilityHint("Submits 'Yes' as your answer for the current question.")
                                
                                
                                Button {
                                    if multiplaySessionViewModel.currentQuestionIndex < (multiplaySessionViewModel.questions.count) {
                                        
                                        
                                        Task{
                                            await    multiplaySessionViewModel.submitAnswer(question: multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].question, questionId: multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].id, answer: false)
                                            
                                            if multiplaySessionViewModel.sessionStatus.isError{
                                                showAlert = true
                                            }
                                        }
                                        
                                        showAnswer = true
                                    }
                                    
                                } label: {
                                    Text("NO")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .frame(height: 60)
                                        .frame(maxWidth: .infinity)
                                        .background(Color(red: 28/255, green: 41/255, blue: 56/255))
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.gray, lineWidth: 1)
                                                .frame(height: 60)
                                                .frame(maxWidth: .infinity)
                                        )
                                }
                                .accessibilityLabel("No button")
                                .accessibilityHint("Submits 'No' as your answer for the current question.")
                            }
                            .padding(20)
                            
                            Text("\(multiplaySessionViewModel.currentQuestionIndex + 1) of \(multiplaySessionViewModel.questions.count) Questions")
                                .foregroundColor(.gray)
                                .accessibilityLabel("Question \(multiplaySessionViewModel.currentQuestionIndex + 1) of \(multiplaySessionViewModel.questions.count)")
                            
                        }
                        
                    }
                    .padding(20)
                    .alert(isPresented: $showAlert){
                        Alert(
                            title: Text("Error occurred"),
                            message: Text("\(HelperFunctions.getUserFriendlyErrorMessage(stringError: MultiplayerSessionViewModel.shared.sessionStatus.errorDescription ?? "Something went wrong"))"),
                            dismissButton: .default(Text("OK"), action: {
                                showAlert = false
                            })
                        )
                    }
                }
                .padding(20)
                
            }
        }
        .navigationDestination(isPresented: $showAnswer, destination: {
            MultiplayerAnswersView()
        })
        .navigationBarBackButtonHidden()
        .onAppear{
            multiplaySessionViewModel.observeForParticipantsStatus()
            multiplaySessionViewModel.observeForActiveParticipants()
            
        }
    }
}

#Preview {
    MultiplayerQuizView()
}
