//
//  QuizView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-04.
//

import SwiftUI

struct QuizView: View {
    @State private var questions: [Question] = []
    var body: some View {
        List(questions) { question in
            Text(question.question)
            
        }
        .task {
            await loadQuestions()
        }
    }
    
    func loadQuestions() async {
         do {
//              questions = try await QuestionsManager.shared.fetchQuestions()
         } catch {
             print("Failed to fetch questions:", error)
         }
     }
}

#Preview {
    QuizView()
}
