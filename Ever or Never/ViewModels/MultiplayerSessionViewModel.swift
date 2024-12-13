//
//  MultiplayerSessionViewModel.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-19.
//

import Foundation
import FirebaseFirestore
import SwiftUICore
import Combine

@MainActor
class MultiplayerSessionViewModel: ObservableObject {
    
    static let shared = MultiplayerSessionViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        setupObservers()
    }
    
    @Published private var gameSessionManager =  GameSessionManager.shared
    @Published private var multiplayerSessionManager = MultiplayerSessionManager();
    
    @Published var currentSessionId : String? = nil
    @Published var questions: [Question] = []
    @Published var yesAnswerCount: Int = 0
    @Published var noAnswerCount: Int = 0
    @Published var answers: [MultiplayerQuestionAnswer] = []
    @Published var participants: [DBUser] = []
    @Published var activeParticipants: [String] = []
    @Published var hostId: String = ""
    @Published var isGameStarted : Bool = false
    @Published var isGameEnded : Bool = false
    @Published var currentQuestionIndex: Int = 0
    @Published var previousQuestionIndex: Int = -1
    @Published private(set) var user: DBUser? = nil
    @Published var score : [String: Int] = [:]
    @Published var sessionStatus : SessionStatus = SessionStatus(isLoading: false, isError: false)
    
    private var participantListener: ListenerRegistration?
    
    private func setSessionError(error: Error) {
        self.sessionStatus.isError = true
        self.sessionStatus.errorDescription = error.localizedDescription
        print("Cannot join the session")
        print(error.localizedDescription)
    }
    
    private func setNoSessionError() {
        self.sessionStatus.isError = false
        self.sessionStatus.errorDescription = nil
    }
    
    func loadCurrentUser() async {
        //        self.sessionStatus.isLoading = true
        //
        //        defer{
        //            self.sessionStatus.isLoading = false
        //        }
        do{
            print("fetching current user")
            let authDataResult = try  AuthenticationManager.shared.getAuthenticatedUser()
            print("auth data fetched", authDataResult)
            self.user = try await UserManager.shared.getUser(id: authDataResult.uid)
            setNoSessionError()
        }catch{
            setSessionError(error: error)
        }
    }
    
    
    
    func loadQuestions(categoriers: [QuestionCategory], totalQuestionCount: Int) async {
        guard let userId = self.user?.id, let userSeenQuestions = self.user?.seenQuestions else {
            print("No session ID available")
            return
        }
        
        
        //        self.sessionStatus.isLoading = true
        //
        //        defer{
        //            self.sessionStatus.isLoading = false
        //        }
        do{
            //            questions = try await QuestionsManager.shared.fetchQuestions(categoriers: categoriers, totalQuestionCount: totalQuestionCount)
            
            questions = try await QuestionsManager.shared.fetchRandomUniqueQuestions(userSeenQuestions: userSeenQuestions, categoriers: categoriers, totalQuestionCount: totalQuestionCount)
            
            
            try await UserHelperFunctions.updateSeenQuestions(userId: userId, userSeenQuestions: userSeenQuestions, questions: questions)
            
            print("Questions were loaded")
            setNoSessionError()
        }catch{
            setSessionError(error: error)
        }
    }
    
    func initializeMultiplayerGameSessions(selectedCategories: [QuestionCategory], totalQuestionCount: Int) async {
        self.sessionStatus.isLoading = true
        
        resetData()
        
        print("running this")
        try await loadCurrentUser()
        await loadQuestions(categoriers:selectedCategories, totalQuestionCount: totalQuestionCount)
        print(questions.count)
        
        defer{
            self.sessionStatus.isLoading = false
        }
        
        do {
            if (!questions.isEmpty && (user != nil)){
                print(questions.count)
                
                let (sessionId, hostId) =  try await multiplayerSessionManager.createMultiplayerSession(hostId: user!.id, numberOfQuestions: totalQuestionCount, qustionCategories: selectedCategories, qustions: self.questions )
                self.currentSessionId = sessionId
                self.hostId = hostId
                print("session created")
                
                
                //                gameSessionManager.sessionID = sessionId
                //                gameSessionManager.isMultiplayerGame = true
                //                gameSessionManager.playerID = user!.id
                //
                //                initializeGameSessionManager(sessionId: sessionId!, playerId: user!.id)
                gameSessionManager.sessionID = sessionId
                gameSessionManager.playerID = user!.id
                gameSessionManager.isMultiplayerGame = true
                
                multiplayerSessionManager.trackUserConnection(sessionId: sessionId!, playerId: user!.id)
            }
            participants.append(user!)
            //            activeParticipants.append(user!.id)
            print(currentSessionId)
            
            setNoSessionError()
        }catch{
            setSessionError(error: error)
        }
    }
    
    func joingGameSession(sessionId: String) async {
        
        self.sessionStatus.isLoading = true
        
        guard let user , let userSeenQuestions = self.user?.seenQuestions else {
            print("No user logged in")
            return
        }
        participants.append(user)
        //        activeParticipants.append(user.id)
        
        defer {
            self.sessionStatus.isLoading = false
        }
        do{
            let _: () = try await multiplayerSessionManager.joinMultiplayerSession(sessionId: sessionId, userId: user.id)
            
            let session = try await multiplayerSessionManager.fetchSession(sessionId: sessionId)
            
            self.currentSessionId = sessionId
            self.questions = session.questions
            try await UserHelperFunctions.updateSeenQuestions(userId: user.id, userSeenQuestions: userSeenQuestions, questions: questions)
            try await updatedParticipants(for: session)
            
            //            initializeGameSessionManager(sessionId: sessionId, playerId: user.id)
            gameSessionManager.sessionID = sessionId
            gameSessionManager.playerID = user.id
            gameSessionManager.isMultiplayerGame = true
            
            
            
            multiplayerSessionManager.trackUserConnection(sessionId: sessionId, playerId: user.id)
            setNoSessionError()
        }catch{
            setSessionError(error: error)
        }
        
    }
    
    func updatedParticipants(for session : MultiplayerQuizSession) async {
        //        self.sessionStatus.isLoading = true
        var updatedParticipants : [DBUser] = []
        
        //        defer {
        //            self.sessionStatus.isLoading = false
        //        }
        
        do{
            for participantId in session.participants {
                if let dbuser = try await fetchParticipantData(for: participantId){
                    updatedParticipants.append(dbuser)
                }
            }
            setNoSessionError()
        }catch{
            setSessionError(error: error)
        }
    }
    
    func fetchParticipantData(for userId : String) async throws -> DBUser? {
        return try await UserManager.shared.getUser(id: userId)
    }
    
    func observeParticipants(for sessionId: String) {
        DispatchQueue.main.async {
            self.participants = [] // Reset participants list on the main thread
        }
        
        multiplayerSessionManager.observeParticipants(
            
            
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
        self.sessionStatus.isLoading = true
        
        var fetchedUsers: [DBUser] = []
        
        for userId in userIds {
            
            defer{
                self.sessionStatus.isLoading = false
            }
            
            do {
                let user = try await UserManager.shared.getUser(id: userId)
                //                print(user)
                fetchedUsers.append(user)
                setNoSessionError()
            } catch {
                print("Error fetching user \(userId): \(error.localizedDescription)")
                setSessionError(error: error)
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
        self.sessionStatus.isLoading = true
        guard let user, let currentSessionId else {
            print("No user logged in")
            return
        }
        defer{
            self.sessionStatus.isLoading = false
        }
        do {
            let updatedSessionData = try await multiplayerSessionManager.submitAnswer(sessionId: currentSessionId, questionId: questionId, question: question , answer: answer, userId: user.id)
            
            
            DispatchQueue.main.async {
                self.answers = updatedSessionData.questionsAndAnswers
            }
            setNoSessionError()
        }catch{
            setSessionError(error: error)
        }
    }
    
    func startQuiz() async {
        
        self.sessionStatus.isLoading = true
        
        guard let currentSessionId else {
            print("No user logged in")
            return
        }
        print("Starting the game")
        
        defer{
            self.sessionStatus.isLoading = true
        }
        
        do{
            let gameStarted = try await multiplayerSessionManager.startQuiz(for: currentSessionId)
            DispatchQueue.main.async {
                
                self.isGameStarted = gameStarted
                print("gameStarted: \(gameStarted)")
                //            print("isGameStarted: \(self.isGameStarted)")
            }
            setNoSessionError()
        }catch{
            setSessionError(error: error)
        }
    }
    
    
    func endQuiz(){
        guard let currentSessionId else {
            print("No user logged in")
            return
        }
        self.isGameStarted = multiplayerSessionManager.endQuiz(for: currentSessionId)
    }
    
    
    func observeSessionStates() {
        guard let currentSessionId else {
            print("No session ID available")
            return
        }
        
        multiplayerSessionManager.observeSession(
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
    
    
    func observeSessionAnswers() {
        DispatchQueue.main.async {
            self.answers = [] // Reset the answers list on the main thread
        }
        guard let currentSessionId else {
            print("No session ID available")
            return
        }
        
        multiplayerSessionManager.observeSession(
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
    
    
    func observeSessionForIndexesUpdate(){
        guard let currentSessionId else {
            print("No session ID available")
            return
        }
        
        multiplayerSessionManager.observeSession(
            for: currentSessionId,
            lookingFor: LookingFor.forCurrentIndex,
            onUpdate: { [weak self] updatedIndexes in
                guard let self = self else { return }
                print("listening ")
                
                DispatchQueue.main.async {
                    if let (currentQuestionIndex, previousQuestionIndex) = updatedIndexes as? (Int, Int){
                        
                        print("currentQuestionIndex: \(currentQuestionIndex), previousQuestionIndex: \(previousQuestionIndex)")
                        self.currentQuestionIndex = currentQuestionIndex
                        self.previousQuestionIndex = previousQuestionIndex
                    }
                }
            },
            onError: { error in
                print("Error observing session: \(error)")
                
            }
        )
        
    }
    
    func updateQuestionIndexes() async{
        self.sessionStatus.isLoading = true
        
        guard let currentSessionId else {
            print("No session ID available")
            return
        }
        
        defer{
            self.sessionStatus.isLoading = false
        }
        
        do{
            try await multiplayerSessionManager.updateQuestionIndexes(for: currentSessionId)
            setNoSessionError()
        }catch{
            setSessionError(error: error)
        }
    }
    
    func stopObservingSession() {
        participantListener?.remove()
        participantListener = nil
        print("Stopped observing for session.")
        //        MultiplayerSessionManager.shared.stopObservingSession()
    }
    
    func updatePreviousQuestionIndexes(){
        print("prev question index: \(self.previousQuestionIndex)")
        if self.previousQuestionIndex < self.questions.count{
            self.previousQuestionIndex += 1
        }
    }
    
    func calculateScores()  {
        // Dictionary to store the scores for each player
        print("Calculating scores...")
        var playerScores: [String: Int] = [:]
        
        for questionAnswer in self.answers {
            // Iterate through each answer in the current question
            for answer in questionAnswer.answers {
                // Extract the player ID and the answer value
                let playerId = answer.playerId
                let isAnswerYes = answer.answer
                
                // Calculate score: Yes = 10, No = 0
                let score = isAnswerYes ? 10 : 0
                
                // Update the player's score
                playerScores[playerId, default: 0] += score
            }
        }
        
        print("Scores: \(playerScores)")
        self.score =  playerScores
    }
    
    func removeQuitedPlayers() async{
        guard let userId = self.user?.id , let currentSessionId else{
            print("No user or session id")
            return
        }
        
        do {
            try await multiplayerSessionManager.removePlayer(sessionId: currentSessionId, playerId: userId)
            resetData()
            
            print("Player removed")
        } catch{
            print("Could not remove player")
        }
    }
    
    private func resetData() {
        currentSessionId = nil
        questions = []
        yesAnswerCount = 0
        noAnswerCount = 0
        answers = []
        participants = []
        hostId = ""
        isGameStarted = false
        isGameEnded = false
        currentQuestionIndex = 0
        previousQuestionIndex = -1
        user = nil
        score = [:]
        sessionStatus = SessionStatus(isLoading: false, isError: false)
        participantListener = nil
        activeParticipants = []
    }
    
    
    
    func observeForParticipantsStatus(){
        guard let currentSessionId else {
            print("No session ID available")
            return
        }
        
        print("observing participants status")
        
        multiplayerSessionManager.observeActiveParticipants(
            for: currentSessionId,
            onUpdate: { [weak self] activePlayers in
                guard let self else { return }
                
                DispatchQueue.main.async {
                    self.activeParticipants = activePlayers
                    print("active participants updated\(activePlayers)")
                }
            }
        )
    }
    
    
    func syncActiveParticipants() async{
        guard let currentSessionId else {
            print("No session ID available")
            return
        }
        
        print("syncing active participants..")
        do {
            try await multiplayerSessionManager.syncActiveParticipantsWithFirestore(sessionId: currentSessionId, activeUsers: activeParticipants)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func setupObservers() {
           Publishers.CombineLatest($participants, $activeParticipants)
               .sink { [weak self] participants, activeParticipants in
                   guard let self = self else { return }
                   if participants.count != activeParticipants.count {
                       Task {
                           await self.syncActiveParticipants()
                       }
                   }
               }
               .store(in: &cancellables)
       }
    
}

//hostId: String, numberOfQuestions: Int, qustionCategories: [QuestionCategory], qustions: [Question]

