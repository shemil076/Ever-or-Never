//
//  QuestionCountSelectionView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-12.
//

import SwiftUI

struct QuestionCountSelectionView: View {
    @State private var selectedQuestionCount = 0
    @Binding var isMultiplePlayerMode : Bool
    @State private var isButtonClicked = false
    @State private var isNavigateToCategoryView : Bool = false
    @State private var isShowAlert : Bool = false
    
    @State private var buttons : [ButtonAttributes] = [
        ButtonAttributes(isButtonClicked: false, associatedValue: QuestionCount.ten),
        ButtonAttributes(isButtonClicked: false, associatedValue: QuestionCount.fifty),
        ButtonAttributes(isButtonClicked: false, associatedValue: QuestionCount.hundred),
        //        ButtonAttributes(isButtonClicked: false, associatedValue: QuestionCount.infinity)
    ]
    
    var body: some View {
        ZStack{
            ViewBackground()
            
            VStack(alignment: .leading,spacing: 20){
                Spacer()
                Text("Question Count")
                    .font(.title)
                    .padding()
                
                //            Picker("Question count", selection: $selectedQuestionCount){
                //                ForEach(1...20, id: \.self){ count in
                //                    Text("\(count)")
                //                }
                //            }.pickerStyle(.wheel)
                //                .padding()
                
                VStack(spacing: 20){
                    ForEach($buttons) { $buttonAttributes in
                        Button {
                            self.selectedQuestionCount = buttonAttributes.associatedValue.rawValue
                            buttonAttributes.isButtonClicked.toggle()
                            
                            if !buttonAttributes.isButtonClicked {
                                self.selectedQuestionCount = 0
                            }
                            
                            for button in buttons.indices {
                                if buttons[button].associatedValue.rawValue != buttonAttributes.associatedValue.rawValue {
                                    buttons[button].isButtonClicked = false
                                }
                            }
                        } label: {
                            Text("\(buttonAttributes.associatedValue.rawValue)")
                                .padding()
                                .frame(width: UIScreen.main.bounds .width * 0.8)
                                .background(buttonAttributes.isButtonClicked ? Color(red: 103/255, green: 134/255, blue: 236/255) : Color(red: 185/255, green: 203/255, blue: 236/246))
                                .foregroundColor(buttonAttributes.isButtonClicked ? .white : .black)
                                .cornerRadius(20)
                        }
                    }
                }
                Spacer()
                
                
                Button {
                    if selectedQuestionCount <= 0 {
                        isShowAlert = true
                    }else{
                        isNavigateToCategoryView = true
                    }
                } label: {
                    Text("CONTINUE")
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.13)
                        .background(Color(red: 78 / 255, green: 130 / 255, blue: 209 / 255))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .padding(.top, 50)
                .alert(isPresented: $isShowAlert) {
                    Alert(
                        title: Text("Question count not selected"),
                        message: Text("Please select question count."),
                        dismissButton: .default(Text("OK"), action: {
                            isShowAlert = false
                        })
                    )
                }
                Spacer()
            
                
                NavigationLink(isActive: $isNavigateToCategoryView) {
                    CategorySelectionView(selectedQuestionCount: $selectedQuestionCount, isMultiplePlayerMode: $isMultiplePlayerMode)
                } label: {
                    EmptyView()
                }.padding(.top, 50)
                Spacer()
            }
            
        }
//        .onAppear {
//            selectedQuestionCount = 0
//        }
        //        .ignoresSafeArea()
    }
}

#Preview {
    QuestionCountSelectionView(isMultiplePlayerMode: .constant(true))
}

struct ButtonAttributes: Identifiable{
    let id = UUID()
    var isButtonClicked: Bool
    var associatedValue: QuestionCount
}

enum QuestionCount: CaseIterable {
    case ten
    case fifty
    case hundred
    //    case infinity
    
    var rawValue: Int {
        switch self {
        case .ten: return 5
        case .fifty: return 50
        case .hundred: return 100
            //        case .infinity: return Int.max
        }
    }
}
