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
        ZStack{
            
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.white, location: 0.0),   // Blue starts at the top
                    .init(color: Color.blue.opacity(0.3), location: 1.0) // Purple starts lower (60% of the view height)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            
            VStack{
                Spacer()
                HStack{
                    Image("bg-girl")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width / 1.8)
                    Spacer()
                }
            }
            
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
                        EmptyView()
                    }
                }
                
            }
        }
//        .ignoresSafeArea()
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
