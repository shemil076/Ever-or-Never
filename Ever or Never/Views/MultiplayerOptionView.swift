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
        NavigationStack{
            ZStack{
                
                ViewBackground()
                    .ignoresSafeArea()
                
                VStack(alignment:.leading, spacing: 50){
                    Text("Multiplayer")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Join Now")
                            .font(.caption)
                            .foregroundColor(.white)
                        
                        ZStack(alignment: .leading) {
                            if sessionIdInput.isEmpty {
                                Text("Enter the code")
                                    .foregroundColor(.gray) // Set placeholder text color
                                    .padding(.leading, 12)   // Match padding inside the TextField
                            }
                            
                            TextField("", text: $sessionIdInput)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                .font(.body)
                                .foregroundColor(.white)
                        }
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
                                await MultiplayerSessionViewModel.shared.joingGameSession(sessionId: sessionIdInput)
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
                            
                                .frame(height: 1)
                                .background(Color.gray)
                        }
                        .padding()
                        
                        Text("Or")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        VStack{
                            Divider()
                                .frame(height: 1)
                                .background(Color.gray)
                        }
                        .padding()
                    }
                    
                    Text("Create a New Session")
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    
                    NavigationLink(destination: QuestionCountSelectionView(isMultiplePlayerMode: .constant(true))){
                        
                        
                        VStack(alignment: .center){
                            ZStack{
                                
                                HStack{
                                    VStack(alignment: .leading){
                                        Text("New Game")
                                            .font(.title)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        
                                        
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.7)
                                    
                                    Image(systemName: "arrow.up.forward")
                                        .foregroundColor(.black)
                                        .background(
                                            Rectangle()
                                                .fill(Color.white)
                                                .frame(width: UIScreen.main.bounds .width * 0.1, height: UIScreen.main.bounds .width * 0.1)
                                                .cornerRadius(50)
                                        )
                                }
                                
                            }.background(
                                Rectangle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: UIScreen.main.bounds .width * 0.9 , height: UIScreen.main.bounds.height * 0.13)
                                    .cornerRadius(15)
                            )
                            
                            .padding(.leading, UIScreen.main.bounds.width * 0.08)
                            
                        }
                        
                    }
                    
                    .disabled(isJoinDisabled)
                    
                }
                .onAppear{
                    Task{
                        await MultiplayerSessionViewModel.shared.loadCurrentUser()
                    }
                }
                .padding()
            }
        }
        .navigationDestination(isPresented: $isGameSessionReady) {
            MultiplayLobby()
        }
    }
}

#Preview {
    MultiplayerOptionView()
}
