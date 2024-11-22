//
//  MultiPlayerQuizStartView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-18.
//

import SwiftUI

struct MultiPlayerQuizStartView: View {
    @State var existingQuizCode: String = ""
    var body: some View {
        VStack(spacing: 200){
            Button {
                print()
            } label: {
                Text("New Quiz")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            VStack{
                HStack{
                    Text("Enter Quiz Code")
                        .font(.headline)
                    TextField("Code", text: $existingQuizCode)
                        .padding()
                        .background(Color.gray.opacity(0.4))
                        .cornerRadius(10)
                }
                
                Button {
                    print()
                } label: {
                    Text("Join")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
                
        }
        .padding()
    }
}

#Preview {
    MultiPlayerQuizStartView()
}
