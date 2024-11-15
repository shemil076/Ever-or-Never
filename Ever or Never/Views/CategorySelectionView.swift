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
                               await initializeGameSession()
                               isGameSessionReady = true // Set to true after initialization completes
                           }
            } label: {
                Text("Start Quiz")
            }
//            .disabled(isGameSessionReady == false)

            
            NavigationLink(
                        destination: GameSessionView(singlePlayerViwModel: singleGameSessionViewModel),
                        isActive: $isGameSessionReady
                    ) {
                        EmptyView() // Keeps the link hidden but active when `isGameSessionReady` is true
                    }

        }.onAppear{
            
        }
    }
    
    
    
    func initializeGameSession() async {
        
        print("question count \(selectedQuestionCount)")
        try? await singleGameSessionViewModel.initializeGameSession(selectedCategories: selectedCategories, selectedQuestionCount: selectedQuestionCount)
        await singleGameSessionViewModel.loadQuestions(categoriers: selectedCategories, totalQuestionCount: selectedQuestionCount)
    }
}

#Preview {
    CategorySelectionView(selectedQuestionCount: .constant(5))
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
