//
//  MultiplayLobby.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-19.
//

import SwiftUI

struct MultiplayLobby: View {
    @StateObject private var multiplaySessionViewModel = MultiplayerSessionViewModel.shared
    @State private var navigateToQuiz = false
    @State private var isCopied: Bool = false
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ZStack{
            ViewBackground()
            
            VStack(spacing: 25) {
                if multiplaySessionViewModel.sessionStatus.isLoading{
                    ProgressView()
                }else{
                    VStack(alignment:.leading) {
                        ZStack{
                            VStack( spacing: 20){
                                HStack{
                                    Text("Session ID")
                                        .font(.title)
                                        .padding(.trailing, UIScreen.main.bounds .width * 0.45 )
                                }
                                
                                HStack{
                                    Text(multiplaySessionViewModel.currentSessionId ?? "id will be generated here")
                                        .font(.title2)
                                        .foregroundColor(.gray)
                                    
                                }
                                .background(
                                    Rectangle()
                                        .fill(.gray.opacity(0.2))
                                        .cornerRadius(10)
                                        .frame(width: UIScreen.main.bounds .width * 0.8 , height: UIScreen.main.bounds.height * 0.07)
                                    
                                )
                                .padding()
                                
                                if multiplaySessionViewModel.currentSessionId != nil {
                                    HStack {
                                        Button {
                                            HelperFunctions.copyToClipboard(id: multiplaySessionViewModel.currentSessionId!, isCopied: $isCopied)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                isCopied = false
                                            }
                                        } label: {
                                            Image(systemName: isCopied ? "document.on.clipboard.fill" : "doc.on.clipboard")
                                                .font(.system(size: 20))
                                                .foregroundColor(.gray)
                                                .frame(width: 44, height: 44)
                                                .accessibilityLabel("Copy Quote")
                                                .accessibilityHint("Copies the current quote to clipboard")
                                        }
                                        
                                        ShareLink(item: "Use this session id to join: \n\n" + multiplaySessionViewModel.currentSessionId! + "\n\n"  + "Ever Ready, Never Bored – Let the Fun Begin! 🎉"){
                                            Image(systemName: "square.and.arrow.up")
                                                .font(.system(size: 20))
                                                .foregroundColor(.gray)
                                                .accessibilityLabel("Share Quote")
                                                .frame(width: 44, height: 44)
                                                .accessibilityHint("Shares the current quote")
                                        }
                                    }
                                }
                                
                                
                            }
                        }
                        
                        .background(
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: UIScreen.main.bounds .width * 0.9 , height: UIScreen.main.bounds.height * 0.25)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                        )
                    }
                   
                    
                    Section {
                        HStack{
                            Text("Participants")
                                .font(.largeTitle)
                            
                            Spacer()
                        }
                        
                        LazyVGrid(columns : adaptiveColumn, spacing:20 ){
                            ForEach(multiplaySessionViewModel.participants, id: \.self){participant in
                                VStack(alignment: .leading) {
                                    Text(participant.displayName)
                                        .font(.headline)
                                }.background(
                                    Rectangle()
                                        .fill(Color(red: 185/255, green: 203/255, blue: 236/246))
                                        .frame(width: UIScreen.main.bounds .width * 0.4 , height: UIScreen.main.bounds.height * 0.07)
                                        .cornerRadius(15)
                                )
                                .padding()
                                
                                
                            }
                        }
                        
                    }.padding()
                    
    //                Spacer()
                    if multiplaySessionViewModel.hostId == multiplaySessionViewModel.user?.id {
                        Button(action: {
                            Task{
                                await multiplaySessionViewModel.startQuiz()
                            }
                        }) {
                            Text("Continue")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                print("sesionId: \(multiplaySessionViewModel.currentSessionId ?? "none")")
                if let sessionId = multiplaySessionViewModel.currentSessionId {
                    multiplaySessionViewModel.observeParticipants(for: sessionId)
                    multiplaySessionViewModel.observeSessionStates()
                    multiplaySessionViewModel.observeForParticipantsStatus()
                    multiplaySessionViewModel.observeForActiveParticipants()
    
                }
            }
            .onDisappear {
                multiplaySessionViewModel.stopObservingParticipants()
                multiplaySessionViewModel.stopObservingSession()
            }
            .onChange(of: multiplaySessionViewModel.isGameStarted) { isGameStarted in
                if isGameStarted {
                    navigateToQuiz = true // Trigger navigation
                }
            }
            .background(
                // Navigation Link triggered programmatically
                NavigationLink(
                    destination: MultiplayerQuizView(),
                    isActive: $navigateToQuiz,
                    label: { EmptyView() }
                )
            )
        }
    }
}


#Preview {
    MultiplayLobby()
}
