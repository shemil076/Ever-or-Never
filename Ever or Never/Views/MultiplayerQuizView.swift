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
    @State private var showAlert : Bool = false
    var body: some View {
        ZStack{
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
                
                VStack {
                    HStack{
                        Text("Select an answer")
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.gray)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .padding(20)
                    if !multiplaySessionViewModel.questions.isEmpty && multiplaySessionViewModel.currentQuestionIndex < multiplaySessionViewModel.questions.count {
                        Text(multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].question)
                            .multilineTextAlignment(.leading)
                            .font(.title)
                        
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
        //                            currentQuestionIndex += 1
                                    
                                }
//                                else {
//                                    // End of quiz logic
//                                   
//                                    
//                                }
                                
                    
                            } label: {
                                Text("Yes")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(height: 60)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                                    .cornerRadius(20)                            }
                            
                            Button {
                                if multiplaySessionViewModel.currentQuestionIndex < (multiplaySessionViewModel.questions.count) {
                                    
                                    
                                    Task{
                                        await    multiplaySessionViewModel.submitAnswer(question: multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].question, questionId: multiplaySessionViewModel.questions[multiplaySessionViewModel.currentQuestionIndex].id, answer: false)
                                        
                                        if multiplaySessionViewModel.sessionStatus.isError{
                                            showAlert = true
                                        }
                                    }
                                    
        //                            currentQuestionIndex += 1
                                    showAnswer = true
                                }
//                                else {
//                                    // End of quiz logic
//                                }
                            } label: {
                                Text("No")
                                    .font(.headline)
                                    .foregroundStyle(.black)
                                    .frame(height: 60)
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 237 / 255.0, green: 239 / 255.0, blue: 240 / 255.0))
                                    .cornerRadius(20)
                            }
                        }
                        .padding(20)
                        
                        Text("\(multiplaySessionViewModel.currentQuestionIndex + 1) of \(multiplaySessionViewModel.questions.count) Questions")
                            .foregroundColor(.gray)
                        
                        NavigationLink(
                            destination: MultiplayerAnswersView(),
                            isActive: $showAnswer
                        ){
                            EmptyView()
                        }
                    }
//                    else{
//                        
//                        ScoreView(singlePlayerViwModel: singlePlayerViwModel)
//                    }
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
           
        } .navigationBarBackButtonHidden()
            .onAppear{
                multiplaySessionViewModel.observeForParticipantsStatus()

            }
    }
}

#Preview {
    MultiplayerQuizView()
}
