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
    @State private var isShowAlert : Bool = false
    
    @StateObject var singleGameSessionViewModel = SinglePlayerSessionViewModel()
    
    @State private var alwaysFalse: Bool = false
    @State private var isGameSessionReady = false
    @State private var isContinueDisabled: Bool = false

    
    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    var body: some View {
        ZStack{
            
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.white, location: 0.0),
                    .init(color: Color.blue.opacity(0.3), location: 1.0)
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
            
//            if singleGameSessionViewModel.sessionStatus.isLoading ?? false{
//                ProgressView()
//            }
//            
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
                    
                    if singleGameSessionViewModel.sessionStatus.isLoading ?? false{
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
//                .alert(isPresented: $isShowAlert) {
//                    Alert(
//                        title: Text("Category not selected!"),
//                        message: Text("Please select at least one category."),
//                        dismissButton: .default(Text("OK"), action: {
//                            isShowAlert = false
//                        })
//                    )
//                }
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
//            .alert(isPresented: $singleGameSessionViewModel.sessionStatus.isError){
//                Alert(
//                    title: Text("Something went wrong"),
//                    message: Text(singleGameSessionViewModel.sessionStatus.errorDescription ?? "Error occurred"),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
        }

        .onAppear{
            isContinueDisabled = false
        }
//                .ignoresSafeArea()
    }
    
    
    
    func initializeGameSession(isMultiplePlayerMode : Bool) async {
        if !isMultiplePlayerMode{
            await singleGameSessionViewModel.initializeGameSession(selectedCategories: selectedCategories, totalQuestionCount:  selectedQuestionCount)
            await singleGameSessionViewModel.loadQuestions(categoriers: selectedCategories, totalQuestionCount: selectedQuestionCount)
        }else{
            
            try await MultiplayerSessionViewModel.shared.initializeMultiplayerGameSessions(selectedCategories: selectedCategories, totalQuestionCount:  selectedQuestionCount)
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
