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
        VStack{
            if let quizSession = quizSession{
                Text
            }
        }
    }
}

#Preview {
    let selectedQuestionCount: Int = 10
    let selectedCategories : [QuestionCategory] = [.lifeEvents, .movies]
    GameSessionView(selectedQuestionCount: selectedQuestionCount, selectedCategories: selectedCategories)
}
