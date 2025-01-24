//
//  QuestionCountSelectionView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-12.
//

import SwiftUI

struct QuestionCountSelectionView: View {
    //    @Environment(\.presentationMode) var presentationMode
    //    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedQuestionCount = 0
    @Binding var isMultiplePlayerMode : Bool
    @State private var isButtonClicked = false
    @State private var isNavigateToCategoryView : Bool = false
    @State private var isShowAlert : Bool = false
    
    @State private var buttons : [ButtonAttributes] = [
        ButtonAttributes(isButtonClicked: false, associatedValue: QuestionCount.five),
        ButtonAttributes(isButtonClicked: false, associatedValue: QuestionCount.ten),
        ButtonAttributes(isButtonClicked: false, associatedValue: QuestionCount.fifty),
        ButtonAttributes(isButtonClicked: false, associatedValue: QuestionCount.hundred),
        //        ButtonAttributes(isButtonClicked: false, associatedValue: QuestionCount.infinity)
    ]
    
    var body: some View {
        NavigationStack{
            ZStack{
                ViewBackground()
                    .ignoresSafeArea()
                
                
                VStack(alignment: .leading, spacing: UIScreen.main.bounds.height / 12){
                    HStack(alignment: .center){
                        VStack(alignment: .leading){
                            Text("Question Count")
                                .font(.title)
                                .foregroundColor(.white)
                                .fontWeight(.semibold)
                                .padding()
                                .accessibilityAddTraits(.isHeader)
                            
                            
                            VStack(spacing: 20){
                                ForEach($buttons) { $buttonAttributes in
                                    Button {
                                        self.selectedQuestionCount = buttonAttributes.associatedValue.rawValue
                                        buttonAttributes.isButtonClicked.toggle()
                                        
                                        if !buttonAttributes.isButtonClicked {
                                            self.selectedQuestionCount = 0
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
                                            .background(buttonAttributes.isButtonClicked ? Color(red: 103/255, green: 134/255, blue: 236/255) : Color(red: 30/255, green: 47/255, blue: 75/255))
                                            .foregroundColor( .white )
                                            .cornerRadius(10)
                                    }
                                    .accessibilityLabel("Select \(buttonAttributes.associatedValue.rawValue) questions")
                                    .accessibilityHint(buttonAttributes.isButtonClicked ? "Selected" : "Double-tap to select")
                                    .accessibilityAddTraits(buttonAttributes.isButtonClicked ? .isSelected : [])
                                }
                            }
                            .padding(.bottom, UIScreen.main.bounds.height / 6)
                        }
                    }
                    
                    
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
                            .cornerRadius(10)
                    }
                    .padding(.bottom, UIScreen.main.bounds.height / 25)
                    .accessibilityLabel("Continue")
                    .accessibilityHint("Navigates to the category selection screen")
                    .alert(isPresented: $isShowAlert) {
                        Alert(
                            title: Text("Question count not selected"),
                            message: Text("Please select question count."),
                            dismissButton: .default(Text("OK"), action: {
                                isShowAlert = false
                            })
                        )
                    }
                    
                }
                
            }
            .navigationDestination(isPresented: $isNavigateToCategoryView) {
                CategorySelectionView(selectedQuestionCount: $selectedQuestionCount, isMultiplePlayerMode: $isMultiplePlayerMode)
            }
        }
        
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
    case five
    case ten
    case fifty
    case hundred
    //    case infinity
    
    var rawValue: Int {
        switch self {
        case .five: return 5
        case .ten: return 10
        case .fifty: return 50
        case .hundred: return 100
            //        case .infinity: return Int.max
        }
    }
}
