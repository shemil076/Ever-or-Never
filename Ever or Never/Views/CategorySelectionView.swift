//
//  CategorySelectionView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-12.
//

import SwiftUI

struct CategorySelectionView: View {
    let selectedQuestionCount : Int
    @State private var selectedCategories: [QuestionCategory] = []
    @State private var availableCategories: [QuestionCategory] = [.adventure,.entertainment]
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
                Task{
                    do {
                        try await initializeGameSession()
                    }catch {
                        print(error)
                    }
                }
            } label: {
                Text("Start Quiz")
            }

        }
    }
    
    
//    Task {
//        do {
//            try await viewModel.signUp()
//            showSignInView = false
//            return
//        }catch {
//
//            print(error)
//        }
//        
//    }
    
    func initializeGameSession() async {
        let newGameSession: () = try! await SinglePlayerSessionManager.shared.createInitialQuizSession(userId: "String", numberOfQuestions: selectedQuestionCount, qustionCategories: selectedCategories)
    }
}

#Preview {
    CategorySelectionView(selectedQuestionCount: 2)
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
