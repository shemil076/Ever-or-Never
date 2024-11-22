//
//  CategorySelectionView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-12.
//

import SwiftUI

struct CategorySelectionView: View {
//    @EnvironmentObject var multiPlayerSessionViewModel : MultiplayerSessionViewModel
//    @StateObject private var multiPlayerSessionViewModel = MultiplayerSessionViewModel()
    @Binding var selectedQuestionCount : Int
    @State private var selectedCategories: [QuestionCategory] = []
    @State private var availableCategories: [QuestionCategory] = QuestionCategory.allCases
    @Binding var isMultiplePlayerMode: Bool
    
    @StateObject var singleGameSessionViewModel = SinglePlayerSessionViewModel()
    
    @State private var isGameSessionReady = false
    var body: some View {
        VStack{
            Text("Select Categories")
                .font(.title)
                .padding()
            
            List(availableCategories, id: \.self){ category in
                MultipleSelectionRow(category: category, isSelected: selectedCategories.contains(category)){
                    if selectedCategories.contains(category){
                        selectedCategories.removeAll{$0 == category}
                    }else{
                        selectedCategories.append(category)
                    }
                }
                
            }
            
            
            Button {
                Task {
                    print("isMultiplePlayerMode: \(isMultiplePlayerMode)")
                    await initializeGameSession(isMultiplePlayerMode: isMultiplePlayerMode)
                    isGameSessionReady = true //
                }
            } label: {
                Text("Start Quiz")
            }
            //            .disabled(isGameSessionReady == false)
            
            
            if !isMultiplePlayerMode{
                NavigationLink(
                    destination: GameSessionView(singlePlayerViwModel: singleGameSessionViewModel),
                    isActive: $isGameSessionReady
                ) {
                    EmptyView() // Keeps the link hidden but active when `isGameSessionReady` is true
                }
            }else{
                NavigationLink(
                    destination: MultiplayLobby(),
                    isActive: $isGameSessionReady
                ) {
                    EmptyView() // Keeps the link hidden but active when `isGameSessionReady` is true
                }
            }
            
        }.onAppear{
            
        }
    }
    
    
    
    func initializeGameSession(isMultiplePlayerMode : Bool) async {
        
        print("question count \(selectedQuestionCount)")
        if !isMultiplePlayerMode{
            print("not multiple player")
            try? await singleGameSessionViewModel.initializeGameSession(selectedCategories: selectedCategories, totalQuestionCount:  selectedQuestionCount)
            await singleGameSessionViewModel.loadQuestions(categoriers: selectedCategories, totalQuestionCount: selectedQuestionCount)
        }else{
            print("multiple player")
            
            try? await MultiplayerSessionViewModel.shared.initializeMultiplayerGameSessions(selectedCategories: selectedCategories, totalQuestionCount:  selectedQuestionCount)
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
        Button(action : action){
            HStack{
                Text(category.rawValue)
                Spacer()
                if isSelected{
                    Image(systemName: "checkmark")
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}
