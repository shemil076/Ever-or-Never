//
//  MultiplayerSessionViewModel.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-19.
//

import Foundation
import FirebaseFirestore


class MultiplayerSessionViewModel: ObservableObject {
    
    static let shared = MultiplayerSessionViewModel()
    
    private init() {
        
    }
    
    @Published var currentSessionId : String? = nil
    @Published var questions: [Question] = []
    @Published var yesAnswerCount: Int = 0
    @Published var noAnswerCount: Int = 0
    @Published var answers: [MultiplayerQuestionAnswer] = []
    @Published var participants: [DBUser] = []
    @Published var hostId: String = ""
    @Published var isGameStarted : Bool = false
    @Published var isGameEnded : Bool = false
    @Published var currentQuestionIndex: Int = 0
    @Published private(set) var user: DBUser? = nil
    
    private var participantListener: ListenerRegistration?
    
    func loadCurrentUser() async throws {
        print("fetching current user")
        let authDataResult = try  AuthenticationManager.shared.getAuthenticatedUser()
        print("auth data fetched", authDataResult)
        self.user = try await UserManager.shared.getUser(id: authDataResult.uid)
    }
    
    
    
    func loadQuestions(categoriers: [QuestionCategory], totalQuestionCount: Int) async {
        questions = try! await QuestionsManager.shared.fetchQuestions(categoriers: categoriers, totalQuestionCount: totalQuestionCount)
        print("Questions were loaded")
    }
    
    func initializeMultiplayerGameSessions(selectedCategories: [QuestionCategory], totalQuestionCount: Int) async throws{
        print("running this")
        try await loadCurrentUser()
        await loadQuestions(categoriers:selectedCategories, totalQuestionCount: totalQuestionCount)
        print(questions.count)
        if (!questions.isEmpty && (user != nil)){
            print(questions.count)
            
            let (sessionId, hostId) =  try! await MultiplayerSessionManager.shared.createMultiplayerSession(hostId: user!.id, numberOfQuestions: totalQuestionCount, qustionCategories: selectedCategories, qustions: self.questions )
            self.currentSessionId = sessionId
            self.hostId = hostId
            print("session created")
        }
        participants.append(user!)
        print(currentSessionId)
    }
    
    func joingGameSession(sessionId: String) async throws{
        guard let user else {
            print("No user logged in")
            return
        }
        participants.append(user)
        
        let _: () = MultiplayerSessionManager.shared.joinMultiplayerSession(sessionId: sessionId, userId: user.id)
        
        let session = try await MultiplayerSessionManager.shared.fetchSession(sessionId: sessionId)
        
        self.currentSessionId = sessionId
        self.questions = session.questions
        
        try await updatedParticipants(for: session)

    }
    
    func updatedParticipants(for session : MultiplayerQuizSession) async throws {
        var updatedParticipants : [DBUser] = []
        
        for participantId in session.participants {
            if let dbuser = try await fetchParticipantData(for: participantId){
                updatedParticipants.append(dbuser)
            }
        }
    }
    
    func fetchParticipantData(for userId : String) async throws -> DBUser? {
        return try await UserManager.shared.getUser(id: userId)
    }
    func observeParticipants(for sessionId: String) {
        DispatchQueue.main.async {
            self.participants = [] // Reset participants list on the main thread
        }
        
        MultiplayerSessionManager.shared.observeParticipants(
            
           
            sessionId: sessionId,
            onUpdate: { [weak self] participantIds in
                guard let self = self else { return }
                
                Task {
                    do {
                        let fetchedUsers = try await self.fetchUsers(for: participantIds)
                        DispatchQueue.main.async {
                            self.participants = fetchedUsers
                            
                        }
                    } catch {
                        print("Error fetching users: \(error.localizedDescription)")
                    }
                }
            },
            onError: { error in
                print("Error observing participants: \(error.localizedDescription)")
            }
        )
    }

    private func fetchUsers(for userIds: [String]) async throws -> [DBUser] {
        var fetchedUsers: [DBUser] = []
        
        for userId in userIds {
            do {
                let user = try await UserManager.shared.getUser(id: userId)
//                print(user)
                fetchedUsers.append(user)
            } catch {
                print("Error fetching user \(userId): \(error.localizedDescription)")
            }
        }
        
        return fetchedUsers
    }


    
    
    func stopObservingParticipants() {
        participantListener?.remove()
        participantListener = nil
        print("Stopped observing participants.")
    }
    
    
    func submitAnswer(question: String, questionId: String, answer: Bool) async{
        guard let user, let currentSessionId else {
            print("No user logged in")
            return
        }
        let updatedSessionData = try? await MultiplayerSessionManager.shared.submitAnswer(sessionId: currentSessionId, questionId: questionId, question: question , answer: answer, userId: user.id)
        

        DispatchQueue.main.async {
            self.answers = updatedSessionData!.questionsAndAnswers
        }
    }
    
    func startQuiz() {
        guard let currentSessionId else {
            print("No user logged in")
            return
        }
        print("Starting the game")

        DispatchQueue.main.async {
            let gameStarted = MultiplayerSessionManager.shared.startQuiz(for: currentSessionId)
                self.isGameStarted = gameStarted
                print("gameStarted: \(gameStarted)")
//            print("isGameStarted: \(self.isGameStarted)")
            }
    }
    
    
    func endQuiz(){
        guard let currentSessionId else {
            print("No user logged in")
            return
        }
        self.isGameStarted = MultiplayerSessionManager.shared.endQuiz(for: currentSessionId)
    }
    
    
    func observeSessionStates() {
        guard let currentSessionId else {
            print("No session ID available")
            return
        }

        MultiplayerSessionManager.shared.observeSession(
            for: currentSessionId,
            lookingFor: .forStates,
            onUpdate: { [weak self] update in
                DispatchQueue.main.async {
                    if let (isGameStarted, isGameEnded) = update as? (Bool, Bool){
                        self?.isGameStarted = isGameStarted
                        self?.isGameEnded = isGameEnded
//                        print("Session state: isGameStarted = \(isGameStarted), isGameEnded = \(isGameEnded)")
                    }
                }
            },
            onError: { error in
                print("Error observing session state: \(error.localizedDescription)")
            }
        )
    }
    
    
//    func observeSessionAnswers(){
//        DispatchQueue.main.async {
//            self.answers = [] // Reset participants list on the main thread
//        }
//        guard let currentSessionId else {
//            print("No session ID available")
//            return
//        }
//        
//        MultiplayerSessionManager.shared.observeSession(
//            for: currentSessionId,
//            lookingFor: .forAnswer,
//            onUpdate: { [weak self] updatedAnswers in
//                guard let self = self else { return }
//                
//                guard let answesr = updatedAnswers as? [MultiplayerQuestionAnswer] else{
//                    return
//                }
//                
//                
//                
//                if !answesr.isEmpty{
//                    DispatchQueue.main.async {
//                        print("Updated answers: \(updatedAnswers)")
//                        self.answers = answesr
//                        
//                        print("Session answers: \(updatedAnswers)")
//                    }
//                } else {
//                    print("Answers are empty   \(updatedAnswers)")
//                }
//            
//                
//            },
//            onError: { error in
//                print("Error observing session: \(error)")
//                
//            }
//        )
//    }
    
    
    func observeSessionAnswers() {
        DispatchQueue.main.async {
            self.answers = [] // Reset the answers list on the main thread
        }
        guard let currentSessionId else {
            print("No session ID available")
            return
        }
        
        MultiplayerSessionManager.shared.observeSession(
            for: currentSessionId,
            lookingFor: .forAnswer,
            onUpdate: { [weak self] updatedAnswers in
                guard let self = self else { return }
                
                guard let questionsArray = updatedAnswers as? [[String: Any]] else {
                    print("Invalid answers format: \(updatedAnswers)")
                    return
                }
                
                let parsedQuestions = questionsArray.compactMap { questionDict -> MultiplayerQuestionAnswer? in
                    guard
                        let id = questionDict["id"] as? String,
                        let question = questionDict["question"] as? String,
                        let answersArray = questionDict["answers"] as? [[String: Any]]
                    else { return nil }
                    
                    let parsedAnswers = answersArray.compactMap { answerDict -> MultiplayerAnswer? in
                        guard
                            let playerId = answerDict["playerId"] as? String,
                            let answer = answerDict["answer"] as? Bool
                        else { return nil }
                        return MultiplayerAnswer(playerId: playerId, answer: answer)
                    }
                    
                    return MultiplayerQuestionAnswer(id: id, question: question, answers: parsedAnswers)
                }
                
                DispatchQueue.main.async {
                    if self.answers != parsedQuestions {
                        self.answers = parsedQuestions
                        print("Session answers updated: \(parsedQuestions)")
                    } else {
                        print("No changes in answers")
                    }
                }
            },
            onError: { error in
                print("Error observing session: \(error)")
            }
        )
    }

   
    
    
    func stopObservingSession() {
        participantListener?.remove()
        participantListener = nil
        print("Stopped observing for session.")
//        MultiplayerSessionManager.shared.stopObservingSession()
    }
    
}

//hostId: String, numberOfQuestions: Int, qustionCategories: [QuestionCategory], qustions: [Question]

