//
//  MultiplayerOptionView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-20.
//

import SwiftUI

struct MultiplayerOptionView: View {
    
    
    @State private var sessionIdInput : String = ""
    @State private var isGameSessionReady = false
    @State private var isSessionIdEmpty = false
    @State private var isSessionIdInvalid = false
    @State private var isJoinDisabled = false
    @State private var showProgressView = false
    
    var body: some View {
        ZStack{
            
            ViewBackground()
            
            VStack(alignment:.leading, spacing: 50){
                Text("Multiplayer")
                    .font(.largeTitle)
                
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Join Now")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("Enter the code", text: $sessionIdInput)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .font(.body)
                }
                
                Button {
                    if sessionIdInput == ""{
                        isSessionIdEmpty = true
                    }else{
                        isJoinDisabled = true
                        
                        print("isLoading \(MultiplayerSessionViewModel.shared.sessionStatus.isLoading)")
                        if MultiplayerSessionViewModel.shared.sessionStatus.isLoading {
                            showProgressView = true
                        }
                        Task{
                            try await MultiplayerSessionViewModel.shared.joingGameSession(sessionId: sessionIdInput)
                            if !MultiplayerSessionViewModel.shared.sessionStatus.isError{
                                isGameSessionReady = true
                            }else{
                                isSessionIdInvalid = true
                            }
                            
                            isJoinDisabled = false
                        }
                        showProgressView = false
                        print("isLoading \(MultiplayerSessionViewModel.shared.sessionStatus.isLoading)")
                    }
                    
                } label: {
                    if showProgressView{
                        ProgressView()
                    }else{
                        Text("JOIN THE GAME")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                }
                .disabled(isJoinDisabled)
                
                
                .alert(isPresented: Binding(get: {
                    isSessionIdEmpty || isSessionIdInvalid
                }, set: { newValue in
                    if !newValue {
                        isSessionIdEmpty = false
                        isSessionIdInvalid = false
                    }
                })){
                    if isSessionIdEmpty{
                        return  Alert(title: Text("Session Id Empty"),
                                      message: Text("Please enter a session id"),
                                      dismissButton: .default(Text("OK")))
                    }else{
                        return Alert(title: Text("Something went wrong"),
                                     message: Text("\(HelperFunctions.getUserFriendlyErrorMessage(stringError: MultiplayerSessionViewModel.shared.sessionStatus.errorDescription ?? "Error occurred"))"),
                                     dismissButton: .default(Text("OK")))
                    }
                }
                
                
                HStack{
                    VStack{
                        Divider()
                            .font(.headline)
                    }
                    .padding()
                    
                    Text("Or")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    VStack{
                        Divider()
                            .font(.headline)
                    }
                    .padding()
                }
                
                Text("Create a New Session")
                    .font(.title)
                
                NavigationLink(destination: QuestionCountSelectionView(isMultiplePlayerMode: .constant(true))){
                    //                    Text("Multiplayer")
                    //                        .font(.headline)
                    //                        .padding()
                    //                        .frame(maxWidth: .infinity)
                    //                        .background(Color.blue)
                    //                        .foregroundColor(.white)
                    //                        .cornerRadius(10)
                    
                    VStack{
                        ZStack{
                            HStack{
                                Spacer()
                                Image("Vector")
                                    .padding(.leading, UIScreen.main.bounds.width * 0.6)
                            }
                            HStack{
                                VStack(alignment: .leading){
                                    Text("New Game")
                                        .font(.title)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    
                                }.padding()
                                    .frame(width: UIScreen.main.bounds.width * 0.7)
                                
                                Image(systemName: "arrow.up.forward")
                                    .foregroundColor(.black)
                                    .background(
                                        Rectangle()
                                            .fill(Color.white)
                                            .frame(width: UIScreen.main.bounds .width * 0.1, height: UIScreen.main.bounds .width * 0.1)
                                            .cornerRadius(50)
                                    )
                                    .padding(.top, 40)
                            }
                            
                        }.background(
                            Rectangle()
                                .fill(Color(red: 103/255, green: 134/255, blue: 236/255))
                                .frame(width: UIScreen.main.bounds .width * 0.9 , height: UIScreen.main.bounds.height * 0.13)
                                .cornerRadius(15)
                        )
                        
                    }
                    
                }.disabled(isJoinDisabled)
                
                //                VStack{
                //                    HStack{
                //                        Text("Join now ")
                //
                //                        TextField("Session Id", text: $sessionIdInput)
                //                            .padding()
                //                            .background(Color.gray.opacity(0.4))
                //                            .cornerRadius(10)
                //                    }
                //
                //                    Button {
                //                        Task{
                //                            try await MultiplayerSessionViewModel.shared.joingGameSession(sessionId: sessionIdInput)
                //                            isGameSessionReady = true
                //                        }
                //                    } label: {
                //                        Text("Start Quiz")
                //                    }
                //
                //
                //                }
                
                NavigationLink(
                    destination: MultiplayLobby(),
                    isActive: $isGameSessionReady
                ) {
                    EmptyView() // Keeps the link hidden but active when `isGameSessionReady` is true
                }
            }
            .onAppear{
                Task{
                    try await MultiplayerSessionViewModel.shared.loadCurrentUser()
                }
            }
            .padding()
        }
    }
}

#Preview {
    MultiplayerOptionView()
}
