//
//  SinglePlayerSessionViewModel.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-13.
//

import Foundation


@MainActor
class SinglePlayerSessionViewModel: ObservableObject{
    
    @Published var currentSessionId : String? = nil
    @Published var questions: [Question] = []
    @Published var yesAnswerCount: Int = 0
    @Published var noAnswerCount: Int = 0
    @Published var answers: [QuestionAnswer] = []
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try  AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(id: authDataResult.uid)
        
        print("User has been loaded")
    }
    
    
    
    func loadQuestions(categoriers: [QuestionCategory], totalQuestionCount: Int) async {
        questions = try! await QuestionsManager.shared.fetchQuestions(categoriers: categoriers, totalQuestionCount: totalQuestionCount)
    }
    
    func initializeGameSession(selectedCategories: [QuestionCategory], totalQuestionCount: Int) async throws{
        try await loadCurrentUser()
        self.currentSessionId = try! await SinglePlayerSessionManager.shared.createInitialQuizSession(userId: user!.id, numberOfQuestions: totalQuestionCount, qustionCategories: selectedCategories)
    }
    
    func submitAnswer(questionId: String, answer: Bool){
        answers.append(QuestionAnswer(question: questionId, answer: answer))
    }
    
//    func calculateScore(){
//        let count = answers.reduce((yes: 0, no: 0)) { counts, answer in
//                if answer.answer {
//                    return (yes: counts.yes + 1, no: counts.no)
//                } else {
//                    return (yes: counts.yes, no: counts.no + 1)
//                }
//        }
//        
//        yesAnswerCount = count.yes
//        noAnswerCount = count.no
//    }
    
    func calculateScore(){
        var score: Int = 0
        for answer in answers {
            if answer.answer {
                score += 10
            }
        }
        self.yesAnswerCount = score
//        self.noAnswerCount = answers.count - score
    }
    
    func completeGameSession() async {
        guard let currentSessionId else {
            print("Error: currentSessionId is nil. Cannot complete the session.")
            return
        }
        
        let currentScore = TypeScore(yesAnswerCount: yesAnswerCount, noAnswerCount: noAnswerCount)
        
        do {
            let _ = try await SinglePlayerSessionManager.shared.completeSessionByUpdatingData(
                sessionId: currentSessionId,
                score: currentScore,
                questionsAnswers: answers
            )
        } catch {
            print("Error completing game session: \(error.localizedDescription)")
        }
    }


}
