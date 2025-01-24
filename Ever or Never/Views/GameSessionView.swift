//
//  GameSessionView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-12.
//

import SwiftUI

struct GameSessionView: View {
    
    @StateObject var singlePlayerViewModel: SinglePlayerSessionViewModel
    @State private var currentQuestionIndex: Int = 0
    @State private var  navigateToScoreView = false
    var body: some View {
        NavigationStack{
            ZStack {
                ViewBackground()
                
                
                ZStack{
                    Rectangle()
                        .fill(Color(red: 28/255, green: 41/255, blue: 56/255))
                        .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 1.4)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(red: 42 / 255, green: 54 / 255, blue: 68 / 255), lineWidth: 1)
                                .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 1.4)
                        )
                    
                    VStack(spacing: 50) {
                        
                        
                        
                        if !singlePlayerViewModel.questions.isEmpty && currentQuestionIndex < singlePlayerViewModel.questions.count {
                            
                            let progress = CGFloat(currentQuestionIndex + 1) / CGFloat(singlePlayerViewModel.questions.count)
                            
                            
                            //                            HStack(alignment:.center){
                            //                                ZStack(alignment: .leading) {
                            //                                    Rectangle()
                            //                                        .frame( height: 10)
                            //                                        .cornerRadius(10)
                            //                                        .foregroundColor(Color.gray.opacity(0.3))
                            //
                            //                                    Rectangle()
                            //                                        .frame(width: progress * UIScreen.main.bounds.width / 2, height: 10)
                            //                                        .cornerRadius(10)
                            //                                        .foregroundColor(.blue)
                            //                                        .animation(.easeInOut, value: progress)
                            //                                }
                            //                                .frame(width: UIScreen.main.bounds.width / 2)
                            //
                            //                                Text(" \(currentQuestionIndex + 1) / \(singlePlayerViewModel.questions.count) ")
                            //                                    .foregroundStyle(.white)
                            //                            }
                            
                            
                            HStack{
                                ProgressView(value: progress)
                                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                                    .frame(maxWidth: .infinity, maxHeight: 20)
                                    .padding(.horizontal)
                                    .accessibilityLabel("Progress")
                                    .accessibilityValue("\(Int(progress * 100)) percent completed")
                                
                                
                                Text(" \(currentQuestionIndex + 1) / \(singlePlayerViewModel.questions.count) ")
                                    .foregroundStyle(.white)
                            }
                            .padding(.horizontal)
                            
                            HStack{
                                Text("Select an answer")
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.gray)
                                    .fontWeight(.semibold)
                                    .accessibilityAddTraits(.isHeader)
                                Spacer()
                            }
                            .padding(.horizontal,10)
                            
                            Text(singlePlayerViewModel.questions[currentQuestionIndex].question)
                                .multilineTextAlignment(.leading)
                                .font(.title)
                                .foregroundColor(.white)
                                .accessibilityLabel("Question: \(singlePlayerViewModel.questions[currentQuestionIndex].question)")
                            
                            VStack(spacing:20){
                                
                                //                                Button {
                                //                                    if currentQuestionIndex < (singlePlayerViwModel.questions.count ) {
                                //
                                //
                                //
                                //                                        singlePlayerViewModel.submitAnswer(questionId: singlePlayerViwModel.questions[currentQuestionIndex].question, answer: true)
                                //
                                //                                        currentQuestionIndex += 1
                                //
                                //                                        if currentQuestionIndex == singlePlayerViwModel.questions.count {
                                //                                            navigateToScoreView = true                                    }
                                //
                                //                                    } else {
                                //                                        // End of quiz logic
                                //
                                //                                    }
                                //
                                //
                                //                                } label: {
                                //                                    Text("Yes")
                                //                                        .font(.headline)
                                //                                        .foregroundStyle(.white)
                                //                                        .frame(height: 60)
                                //                                        .frame(maxWidth: .infinity)
                                //                                        .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                                //                                        .cornerRadius(20)
                                //                                }
                                //
                                AnswerButton(text: "Yes", backgroundColor: Color(red: 78/255, green: 130/255, blue: 209/255)) {
                                    handleAnswer(isYes: true)
                                }
                                
                                //                                Button  {
                                //                                    if currentQuestionIndex < (singlePlayerViwModel.questions.count) {
                                //
                                //
                                //                                        singlePlayerViwModel.submitAnswer(questionId: singlePlayerViwModel.questions[currentQuestionIndex].question, answer: false)
                                //
                                //                                        currentQuestionIndex += 1
                                //                                        if currentQuestionIndex == singlePlayerViwModel.questions.count {
                                //                                            navigateToScoreView = true                                    }
                                //                                    } else {
                                //                                    }
                                //                                } label: {
                                //                                    Text("NO")
                                //                                        .font(.headline)
                                //                                        .foregroundStyle(.white)
                                //                                        .frame(height: 60)
                                //                                        .frame(maxWidth: .infinity)
                                //                                        .background(Color(red: 28/255, green: 41/255, blue: 56/255))
                                //                                        .cornerRadius(20)
                                //                                        .overlay(
                                //                                            RoundedRectangle(cornerRadius: 15)
                                //                                                .stroke(Color.gray, lineWidth: 1)
                                //                                                .frame(height: 60)
                                //                                                .frame(maxWidth: .infinity)
                                //                                        )
                                //                                }
                                AnswerButton(text: "No", backgroundColor: Color(red: 28/255, green: 41/255, blue: 56/255)) {
                                    handleAnswer(isYes: false)
                                }
                                
                            }
                            .padding(20)
                            
                            Text("\(currentQuestionIndex + 1) of \(singlePlayerViewModel.questions.count) Questions")
                                .foregroundColor(.gray)
                                .accessibilityLabel("\(currentQuestionIndex + 1) out of \(singlePlayerViewModel.questions.count) questions")
                        }
                        
                    }
                    .padding(20)
                }
                .padding(20)
                
            }
            .navigationDestination(isPresented:  $navigateToScoreView) {
                ScoreView(singlePlayerViwModel: singlePlayerViewModel)
            }
        }
        .alert(isPresented: $singlePlayerViewModel.sessionStatus.isError){
            Alert(
                title: Text("Something went wrong"),
                message: Text(singlePlayerViewModel.sessionStatus.errorDescription ?? "An unhandled error occurred."),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarBackButtonHidden()
    }
    
    
    private func handleAnswer(isYes: Bool){
        guard currentQuestionIndex < (singlePlayerViewModel.questions.count) else { return}
        
        let questionId = singlePlayerViewModel.questions[currentQuestionIndex].question
        singlePlayerViewModel.submitAnswer(questionId: questionId, answer: isYes)
        
        
        if currentQuestionIndex + 1 == singlePlayerViewModel.questions.count {
            navigateToScoreView = true
        } else {
            currentQuestionIndex += 1
        }
    }
}

#Preview {
    
    GameSessionView(singlePlayerViewModel: SinglePlayerSessionViewModel())
}


struct AnswerButton: View {
    let text: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.headline)
                .foregroundColor(.white)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(backgroundColor == Color(red: 28/255, green: 41/255, blue: 56/255) ? Color.gray : .clear, lineWidth: 1)
                )
        }
        .accessibilityLabel(text)
        .padding(.horizontal)
    }
}
