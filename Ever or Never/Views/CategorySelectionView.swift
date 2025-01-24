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
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                ViewBackground()
                    .ignoresSafeArea()
                
                
                VStack(){
                    
                    HeaderView()
                    
                    CategorySelectionGrid(
                        availableCategories: QuestionCategory.allCases,
                        selectedCategories: $selectedCategories
                    )
                    ContinueButton(
                        isLoading: singleGameSessionViewModel.sessionStatus.isLoading,
                        isDisabled: isContinueDisabled,
                        action: continueButtonAction
                    )
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
                }
                .navigationDestination(isPresented: $isGameSessionReady) {
                    if isMultiplePlayerMode {
                        MultiplayLobby()
                    } else {
                        GameSessionView(singlePlayerViewModel: singleGameSessionViewModel)
                    }
                }
                
            }
            
        }
        .onAppear{
            isContinueDisabled = false
        }
    }
    
    
    private func continueButtonAction(){
        if selectedCategories.isEmpty {
            isShowAlert = true
        }else{
            isContinueDisabled = true
            Task {
                print("isMultiplePlayerMode: \(isMultiplePlayerMode)")
                await initializeGameSession(isMultiplePlayerMode: isMultiplePlayerMode)
                isGameSessionReady = true
            }
        }
    }
    
    private func initializeGameSession(isMultiplePlayerMode : Bool) async {
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
            
            Text(category.rawValue)
                .foregroundColor(.white )
                .background(
                    Rectangle()
                        .fill(isSelected ?Color(red: 103/255, green: 134/255, blue: 236/255) : Color(red: 30/255, green: 47/255, blue: 75/255))
                        .frame(width: UIScreen.main.bounds.width * 0.4 ,height:   UIScreen.main.bounds.height / 15)
                        .cornerRadius(15)
                )
        }
        .accessibilityLabel(category.rawValue)
        .accessibilityHint("Tap to select or deselect the category")
        .padding(.horizontal, 40)
        .padding(.vertical, 10)
        
    }
}

struct CategorySelectionGrid : View {
    
    let availableCategories: [QuestionCategory]
    @Binding var selectedCategories: [QuestionCategory]
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView{
            LazyVGrid(columns: adaptiveColumns, spacing: 30){
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
            
        }
        .frame(height: UIScreen.main.bounds.height / 1.5)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Category selection grid")
        .accessibilityHint("Tap to select or deselect categories")
    }
}

struct HeaderView: View {
    var body: some View {
        HStack{
            Text("Category Selection")
                .font(.title)
                .foregroundStyle(.white)
                .fontWeight(.semibold)
                .padding()
                .accessibilityLabel("Category Selection Header")
                .accessibilityHint("Displays the title for category selection screen")
            Spacer()
        }
    }
}
