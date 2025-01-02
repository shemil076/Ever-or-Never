//
//  CategorySelectionView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-12.
//

import SwiftUI

struct CategorySelectionView: View {
    
    @Binding var selectedQuestionCount : Int
    @State private var selectedCategories: [QuestionCategory] = []
    @State private var availableCategories: [QuestionCategory] = QuestionCategory.allCases
    @Binding var isMultiplePlayerMode: Bool
    @State private var isShowAlert : Bool = false
    
    @StateObject var singleGameSessionViewModel = SinglePlayerSessionViewModel()
    
    @State private var alwaysFalse: Bool = false
    @State private var isGameSessionReady = false
    @State private var isContinueDisabled: Bool = false
    
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    var body: some View {
        NavigationStack{
            ZStack{
                ViewBackground()
                    .ignoresSafeArea()
                
                //
                VStack(){
                    HStack{
                        Text("Category Selection")
                            .font(.title)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .padding()
                        
                        Spacer()
                    }
                    //                .padding(.top , UIScreen.main.bounds.height / 10)
                    ScrollView{
                        LazyVGrid(columns: adaptiveColumn, spacing: 30){
                            ForEach(availableCategories, id: \.self){ category in
                                MultipleSelectionRow(category: category, isSelected: selectedCategories.contains(category)){
                                    if selectedCategories.contains(category){
                                        selectedCategories.removeAll{$0 == category}
                                    }else{
                                        selectedCategories.append(category)
                                    }
                                }
                                
                            }
                        }
                        .padding(.horizontal, UIScreen.main.bounds.width / 15 )
                        .padding(.vertical,30)
                        
                    }.frame(height: UIScreen.main.bounds.height / 1.5)
                    
                    Button {
                        
                        if selectedCategories.isEmpty {
                            isShowAlert = true
                        }else{
                            isContinueDisabled = true
                            Task {
                                print("isMultiplePlayerMode: \(isMultiplePlayerMode)")
                                await initializeGameSession(isMultiplePlayerMode: isMultiplePlayerMode)
                                isGameSessionReady = true //
                            }
                        }
                        
                    } label: {
                        
                        if singleGameSessionViewModel.sessionStatus.isLoading{
                            ProgressView()
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                                .cornerRadius(10)
                        } else{
                            
                            Text("CONTINUE")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                                .cornerRadius(10)
                        }
                        
                        
                    }.disabled(isContinueDisabled)
                    
                        .padding(.horizontal, 20)
                    
                        .alert(isPresented: Binding(get: {
                            isShowAlert || (singleGameSessionViewModel.sessionStatus.isError)
                        }, set: { newValue in
                            if !newValue {
                                isShowAlert = false
                                singleGameSessionViewModel.sessionStatus.isError = false
                            }
                        })) {
                            if isShowAlert {
                                return Alert(
                                    title: Text("Category not selected!"),
                                    message: Text("Please select at least one category."),
                                    dismissButton: .default(Text("OK"), action: {
                                        isShowAlert = false
                                    })
                                )
                            } else {
                                return Alert(
                                    title: Text("Something went wrong"),
                                    message: Text(singleGameSessionViewModel.sessionStatus.errorDescription ?? "Error occurred"),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                        }
                    
                    
                    
                    //                    if !isMultiplePlayerMode{
                    //                        NavigationLink(
                    //                            destination: GameSessionView(singlePlayerViwModel: singleGameSessionViewModel),
                    //                            isActive: $isGameSessionReady
                    //                        ) {
                    //                            EmptyView() // Keeps the link hidden but active when `isGameSessionReady` is true
                    //                        }
                    //                    }else{
                    //                        NavigationLink(
                    //                            destination: MultiplayLobby(),
                    //                            isActive: $isGameSessionReady
                    //                        ) {
                    //                            EmptyView()
                    //                        }
                    //                    }
                }
                .navigationDestination(isPresented: $isGameSessionReady) {
                    if isMultiplePlayerMode {
                        MultiplayLobby()
                    } else {
                        GameSessionView(singlePlayerViwModel: singleGameSessionViewModel)
                    }
                }
                
            }
            
        }
        .onAppear{
            isContinueDisabled = false
        }
    }
    
    
    
    func initializeGameSession(isMultiplePlayerMode : Bool) async {
        if !isMultiplePlayerMode{
            await singleGameSessionViewModel.initializeGameSession(selectedCategories: selectedCategories, totalQuestionCount:  selectedQuestionCount)
            await singleGameSessionViewModel.loadQuestions(categories: selectedCategories, totalQuestionCount: selectedQuestionCount)
        }else{
            
            await MultiplayerSessionViewModel.shared.initializeMultiplayerGameSessions(selectedCategories: selectedCategories, totalQuestionCount:  selectedQuestionCount)
        }
    }
}

#Preview {
    CategorySelectionView(selectedQuestionCount: .constant(5), isMultiplePlayerMode: .constant(true))
}


struct MultipleSelectionRow : View {
    var category: QuestionCategory
    var isSelected: Bool
    var action:() -> Void
    
    var body: some View {
        
        
        Button {
            action()
        } label: {
            //            ZStack{
            Text(category.rawValue)
                .foregroundColor(.white )
                .background(
                    Rectangle()
                        .fill(isSelected ?Color(red: 103/255, green: 134/255, blue: 236/255) : Color(red: 30/255, green: 47/255, blue: 75/255))
                        .frame(width: UIScreen.main.bounds.width * 0.4 ,height:   UIScreen.main.bounds.height / 15)
                        .cornerRadius(15)
                )
            //            }
            
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 10)
        
    }
}
