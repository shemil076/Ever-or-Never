//
//  QuizView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-04.
//

import SwiftUI

struct QuizView: View {
    var body: some View {
        VStack{
            Text("The questio goes here")
                .padding()
            
            Button {
            
            } label: {
                Text("Yes")
            }.padding()

            Button {
            
            } label: {
                Text("No")
            }.padding()
            
        }
    }
}

#Preview {
    QuizView()
}
