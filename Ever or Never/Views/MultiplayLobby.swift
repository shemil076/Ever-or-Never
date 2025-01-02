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
        NavigationStack{
            ZStack{
                ViewBackground()
                    .ignoresSafeArea()
                
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
                                            .foregroundColor(.white)
                                            .padding(.trailing, UIScreen.main.bounds .width * 0.45 )
                                    }
                                    
                                    HStack{
                                        Text(multiplaySessionViewModel.currentSessionId ?? "id will be generated here")
                                            .font(.title2)
                                            .foregroundColor(.white.opacity(0.8))
                                        
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
                                                    .foregroundColor(.white)
                                                    .frame(width: 44, height: 44)
                                                    .accessibilityLabel("Copy Quote")
                                                    .accessibilityHint("Copies the current quote to clipboard")
                                            }
                                            
                                            ShareLink(item: "Use this session id to join: \n\n" + multiplaySessionViewModel.currentSessionId! + "\n\n"  + "Ever Ready, Never Bored – Let the Fun Begin! 🎉"){
                                                Image(systemName: "square.and.arrow.up")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.white)
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
                                    .fill(Color(red: 28/255, green: 41/255, blue: 56/255))
                                    .frame(width: UIScreen.main.bounds .width * 0.9 , height: UIScreen.main.bounds.height * 0.25)
                                    .cornerRadius(20)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color(red: 42 / 255, green: 54 / 255, blue: 68 / 255), lineWidth: 1)
                                            .frame(width: UIScreen.main.bounds .width * 0.9 , height: UIScreen.main.bounds.height * 0.25)
                                    )
                            )
                        }
                        
                        
                        Section {
                            HStack{
                                Text("Participants")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            
                            LazyVGrid(columns : adaptiveColumn, spacing:20 ){
                                ForEach(multiplaySessionViewModel.participants, id: \.self){participant in
                                    VStack(alignment: .leading) {
                                        Text(participant.displayName)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                    }.background(
                                        Rectangle()
                                            .fill(Color(red: 30/255, green: 47/255, blue: 75/255))
                                            .frame(width: UIScreen.main.bounds .width * 0.4 , height: UIScreen.main.bounds.height * 0.07)
                                            .cornerRadius(15)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(Color(red: 53 / 255, green: 68 / 255, blue: 93 / 255), lineWidth: 1)
                                                    .frame(width: UIScreen.main.bounds .width * 0.4 , height: UIScreen.main.bounds.height * 0.07)
                                            )
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
                            .padding(.top, 20)
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
                .onChange(of: multiplaySessionViewModel.isGameStarted) {
                    if  multiplaySessionViewModel.isGameStarted {
                        navigateToQuiz = true // Trigger navigation
                    }
                }
                .background(
                    
                    EmptyView()
                        .navigationDestination(isPresented: $navigateToQuiz) {
                            MultiplayerQuizView()
                        }
                )
            }
        }
        
    }
}


#Preview {
    MultiplayLobby()
}
