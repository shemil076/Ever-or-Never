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
    @Published var sessionStatus : SessionStatus = SessionStatus(isLoading: false, isError: false)
    
    
    @Published private(set) var user: DBUser? = nil
    
    private func setSessionError(error: Error) {
        sessionStatus.isError = true
        sessionStatus.errorDescription = error.localizedDescription
        print(error.localizedDescription)
    }
    
    private func setNoSessionError() {
        sessionStatus.isError = false
        sessionStatus.errorDescription = nil
    }
    
    func loadCurrentUser() async  {
        sessionStatus.isLoading = true
        
        defer{
            sessionStatus.isLoading = false
        }
        
        
        do{
            
            let authDataResult = try  AuthenticationManager.shared.getAuthenticatedUser()
            self.user = try await UserManager.shared.getUser(id: authDataResult.uid)
            
            setNoSessionError()
            print("User has been loaded")
        }catch{
            setSessionError(error: error)
        }
        
    }
    
    
    
    func loadQuestions(categoriers: [QuestionCategory], totalQuestionCount: Int) async {
        guard let userId = self.user?.id, let userSeenQuestions = self.user?.seenQuestions else {
            print("No user id available")
            return
        }
        
        sessionStatus.isLoading = true
        
        defer{
            sessionStatus.isLoading = false
        }
    
        do{
//            fetchRandomUniqueQuestions
            
            questions = try  await QuestionsManager.shared.fetchRandomUniqueQuestions(userSeenQuestions: userSeenQuestions, categoriers: categoriers, totalQuestionCount: totalQuestionCount)
//            questions = try  await QuestionsManager.shared.fetchQuestions(categoriers: categoriers, totalQuestionCount: totalQuestionCount)
            
            try await UserHelperFunctions.updateSeenQuestions(userId: userId, userSeenQuestions: userSeenQuestions, questions: questions)
//            let extractedQuestionIds = questions.reduce(into: [String]()){ result, item in
//                result.append(item.id)
//            }
//            
//            let _ = try await UserManager.shared.saveSeenQuestions(id: userId, seenQuestions: userSeenQuestions, newQuestions:Set(extractedQuestionIds))
            setNoSessionError()
        }catch{
            setSessionError(error: error)
        }
    }
    
    func initializeGameSession(selectedCategories: [QuestionCategory], totalQuestionCount: Int) async {
        sessionStatus.isLoading = true
        
        defer{
            sessionStatus.isLoading = false
        }
        
        do{
            await loadCurrentUser()
            self.currentSessionId = try await SinglePlayerSessionManager.shared.createInitialQuizSession(userId: user!.id, numberOfQuestions: totalQuestionCount, qustionCategories: selectedCategories)
            setNoSessionError()
        }catch{
            setSessionError(error: error)
        }
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
        sessionStatus.isLoading = true
        
        guard let currentSessionId else {
            print("Error: currentSessionId is nil. Cannot complete the session.")
            sessionStatus.isError   = true
            sessionStatus.errorDescription = "Cannot find the session id"
            sessionStatus.isLoading = false
            return
        }
        
        let currentScore = TypeScore(yesAnswerCount: yesAnswerCount, noAnswerCount: noAnswerCount)
        
        defer{
            sessionStatus.isLoading = false
        }
        
        do {
            let _ = try await SinglePlayerSessionManager.shared.completeSessionByUpdatingData(
                sessionId: currentSessionId,
                score: currentScore,
                questionsAnswers: answers
            )
            
            setNoSessionError()
        } catch {
            setSessionError(error: error)
            print("Error completing game session: \(error.localizedDescription)")
        }
    }
    
    
}
