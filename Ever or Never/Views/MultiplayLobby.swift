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
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ZStack{
            ViewBackground()
            
            VStack(spacing: 25) {
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
                            
                            HStack {
                                Image(systemName: "document.on.document.fill")
                                    .foregroundColor(.gray)
                                    .frame(width: 44, height: 44)
                                
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.gray)
                                    .frame(width: 44, height: 44)

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
                    
                    // Displaying the list of participants
                    //                    List(multiplaySessionViewModel.participants) { participant in
                    //                        VStack(alignment: .leading) {
                    //                            Text(participant.displayName)
                    //                                .font(.headline)
                    //                            Text(participant.id)
                    //                                .font(.subheadline)
                    //                                .foregroundColor(.gray)
                    //                        }
                    //                    }
                }.padding()
                
//                Spacer()
                if multiplaySessionViewModel.hostId == multiplaySessionViewModel.user?.id {
                    Button(action: {
                        multiplaySessionViewModel.startQuiz()
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
            .padding()
            .onAppear {
                print("sesionId: \(multiplaySessionViewModel.currentSessionId ?? "none")")
                if let sessionId = multiplaySessionViewModel.currentSessionId {
                    multiplaySessionViewModel.observeParticipants(for: sessionId)
                    multiplaySessionViewModel.observeSessionStates()
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
