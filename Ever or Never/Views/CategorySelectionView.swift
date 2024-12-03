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
    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
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
            
            VStack(spacing: 10){
                Text("Category Selection")
                    .font(.title)
                    .padding()
                ScrollView{
                    
                    
                    //                List(availableCategories, id: \.self){ category in
                    //                    MultipleSelectionRow(category: category, isSelected: selectedCategories.contains(category)){
                    //                        if selectedCategories.contains(category){
                    //                            selectedCategories.removeAll{$0 == category}
                    //                        }else{
                    //                            selectedCategories.append(category)
                    //                        }
                    //                    }
                    //
                    //                }
                    
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
                    }.padding(.horizontal, UIScreen.main.bounds.width / 15 )
                        .padding(.vertical,30)
                    
                    
                    //                LazyVGrid(columns : adaptiveColumn, spacing:20 ){
                    //                    ForEach(multiplaySessionViewModel.participants, id: \.self){participant in
                    //                        VStack(alignment: .leading) {
                    //                            Text(participant.displayName)
                    //                                .font(.headline)
                    //                        }.background(
                    //                            Rectangle()
                    //                                .fill(Color(red: 185/255, green: 203/255, blue: 236/246))
                    //                                .frame(width: UIScreen.main.bounds .width * 0.4 , height: UIScreen.main.bounds.height * 0.07)
                    //                                .cornerRadius(15)
                    //                        )
                    //                        .padding()
                    //
                    //
                    //                    }
                    //                }
                    
                    
                    
                }
                
                Button {
                    Task {
                        print("isMultiplePlayerMode: \(isMultiplePlayerMode)")
                        await initializeGameSession(isMultiplePlayerMode: isMultiplePlayerMode)
                        isGameSessionReady = true //
                    }
                } label: {
                    Text("CONTINUE")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
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
//                .ignoresSafeArea()
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
        //        Button(action : action){
        //            ZStack{
        //                Text(category.rawValue)
        //                    .foregroundColor(isSelected ? .white : .black)
        //            }
        //            .background(
        //                Rectangle()
        //                    .fill(isSelected ?Color(red: 103/255, green: 134/255, blue: 236/255) : Color(red: 185/255, green: 203/255, blue: 236/246))
        //                    .frame(width: UIScreen.main.bounds.width * 0.4 ,height:   UIScreen.main.bounds.height / 15)
        //                    .cornerRadius(15)
        //            )
        //        }.padding(.horizontal, 40)
        //            .padding(.vertical, 10)
        
        Button {
            action()
        } label: {
//            ZStack{
                Text(category.rawValue)
                    .foregroundColor(isSelected ? .white : .black)
                    .background(
                        Rectangle()
                            .fill(isSelected ?Color(red: 103/255, green: 134/255, blue: 236/255) : Color(red: 185/255, green: 203/255, blue: 236/246))
                            .frame(width: UIScreen.main.bounds.width * 0.4 ,height:   UIScreen.main.bounds.height / 15)
                            .cornerRadius(15)
                    )
//            }
            
        }.padding(.horizontal, 40)
            .padding(.vertical, 10)
        
    }
}
