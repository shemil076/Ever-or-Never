//
//  QuestionCountSelectionView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-12.
//

import SwiftUI

struct QuestionCountSelectionView: View {
    @State private var selectedQuestionCount = 5
    
    var body: some View {
        VStack(spacing: 20){
            Text("Select Number of Questions")
                .font(.title)
                .padding()
            
            Picker("Question count", selection: $selectedQuestionCount){
                ForEach(5...20, id: \.self){ count in
                    Text("\(count)")
                }
            }.pickerStyle(.wheel)
                .padding()
            
            NavigationLink {
                CategorySelectionView(selectedQuestionCount: selectedQuestionCount)
            } label: {
                Text("NEXT")
            }

        }
    }
}

#Preview {
    QuestionCountSelectionView()
}
