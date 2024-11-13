//
//  GameSessionView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-12.
//

import SwiftUI

struct GameSessionView: View {
    let selectedQuestionCount: Int
    let selectedCategories : [QuestionCategory]
    
    @State private var quizSession : SinglePlayerQuizSession?
    @State private var currentQuestionIndex: Int = 0
    @State private var questions: [Question] = []
    var body: some View {
        VStack {
               if let quizSession = quizSession {
                   Text("Question \(currentQuestionIndex + 1) of \(quizSession.numberOfQuestions)")
                       .font(.headline)
                       .padding()
                   
                   // Placeholder for question text
//                   Text(questions[currentQuestionIndex])
//                       .font(.title2)
//                       .padding()
                   
                   Button("Next") {
                       if currentQuestionIndex < quizSession.numberOfQuestions - 1 {
                           currentQuestionIndex += 1
                       } else {
                           // End of quiz logic
                       }
                   }
                   .padding()
               } else {
                   Text("Starting your quiz...")
                       .onAppear {
//                           initializeQuizSession()
                       }
               }
           }
           .padding()
    }
//    
//    private func initializeQuizSession() {
//          let userId = "user123" // Replace with actual user ID
//        SinglePlayerSessionManager.shared.createInitialQuizSession(userId: userId, numberOfQuestions: selectedQuestionCount, qustionCategories: selectedCategories) { result in
//              switch result {
//              case .success(let session):
//                  self.quizSession = session
//                  loadQuestions(for: session)
//              case .failure(let error):
//                  print("Error initializing quiz session: \(error)")
//              }
//          }
//      }
      
      private func loadQuestions(for session: SinglePlayerQuizSession) {
          // This function would fetch questions from a database or API based on selected categories.
          // For now, we're using placeholders.
//          self.questions = Array(repeating: "Sample Question", count: session.numberOfQuestions)
      }
}

#Preview {
    let selectedQuestionCount: Int = 10
    let selectedCategories : [QuestionCategory] = [.adventure, .entertainment]
    GameSessionView(selectedQuestionCount: selectedQuestionCount, selectedCategories: selectedCategories)
}
