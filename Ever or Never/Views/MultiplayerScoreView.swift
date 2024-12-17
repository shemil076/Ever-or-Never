//
//  MultiplayerScoreView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-25.
//

import SwiftUI

struct MultiplayerScoreView: View {
    @StateObject private var multiplaySessionViewModel = MultiplayerSessionViewModel.shared
    @State private var showSignInView: Bool = false
    @State private var navigateToModeSelection: Bool = false
    @State private var showAlert : Bool = false
    var body: some View {
        ZStack{
            Spacer()
            ViewBackground()
            VStack{
                HStack{
                    Text("Scoreboard")
                        .font(.largeTitle)
                    Spacer()
                }
                .padding(20)
                
                HStack{
                    Text("Rank")
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    Spacer()
                    Text("Name")
                        .foregroundColor(.white)
                    Spacer()
                    Text("Points")
                        .foregroundColor(.white)
                        .padding(.trailing, 20)
                }.background(
                    Rectangle()
                        .background(Color.black)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(15)
                        
                )
               
                .padding(20)
                
                ForEach(Array(multiplaySessionViewModel.score.sorted(by: { $0.value > $1.value }).enumerated()), id: \.element.key) { index, element in
                    // Extract values to simplify the code inside ForEach
                    let userDisplayName = multiplaySessionViewModel.participants
                        .first(where: { $0.id == element.key })?.displayName ?? "Unknown"
                    let rank = index + 1
                    let score = element.value

                    HStack {
                        // Display rank
                        Text("#\(rank)")
                            .foregroundColor(.black)
                            .padding(.leading, 30)

                        Spacer()

                        // Display user display name
                        Text(userDisplayName)
                            .foregroundColor(.black)

                        Spacer()

                        // Display score
                        Text("\(score)")
                            .foregroundColor(.black)
                            .padding(.trailing, 30)
                    }
                    .frame(height: 60) // Frame for HStack
                    .background(Color(red: 183 / 255, green: 207 / 255, blue: 241 / 255))
                    .cornerRadius(15)
                    .padding(.horizontal,20) // Optional padding for spacing
                    .overlay{
                        if rank == 1 {
                            Image("cup")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                                .rotationEffect(Angle(degrees: -10))
                                .offset(x: -UIScreen.main.bounds.width / 2.5)
                        }
                    }
                    
                }

                
//           #AE82D1
//                List(multiplaySessionViewModel.score.sorted(by: { $0.key < $1.key }), id: \.key) { playerId, score in
//                    HStack {
//                        Text("Player ID: \(playerId)")
//                            .font(.body)
//                        Spacer()
//                        Text("Score: \(score)")
//                            .font(.headline)
//                    }
//                    .padding(.vertical, 5)
//                    
//                }
                
                Spacer()
                VStack(spacing:30){
                    Button {
                        navigateToModeSelection = true
                    } label: {
                        Text("New Game")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 10)
                .padding(20)
                
                
                NavigationLink(isActive: $navigateToModeSelection) {
                    GameModeSelectionView(showSignInView: $showSignInView)
                } label: {
                    EmptyView()
                }

            }
//            .alert(isPresented: )
            
            
            .padding(20)
            .navigationBarBackButtonHidden()
            .onAppear {
                print("Multiplayer Score View Appeared")
                multiplaySessionViewModel.calculateScores()
                multiplaySessionViewModel.endQuiz()
                multiplaySessionViewModel.observeForParticipantsStatus()
                multiplaySessionViewModel.observeForActiveParticipants()

            }
            .onDisappear(){
                multiplaySessionViewModel.stopObservingSession()
                multiplaySessionViewModel.resetData()
            }
        }
    }
}

#Preview {
    MultiplayerScoreView()
}
