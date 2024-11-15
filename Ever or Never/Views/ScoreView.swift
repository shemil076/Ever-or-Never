//
//  ScoreView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-15.
//

import SwiftUI

struct ScoreView: View {
    @StateObject var singlePlayerViwModel: SinglePlayerSessionViewModel
    var body: some View {
        VStack{
            Text("Score")
                .font(.largeTitle)
            
            VStack{
                HStack(spacing:20){
                    Text("Number of yes answers")
                    
                    Text("\(singlePlayerViwModel.yesAnswerCount)")
                }
                HStack(spacing:20){
                    Text("Number of no answers")
                
                    Text("\(singlePlayerViwModel.noAnswerCount)")
                }
            }.padding()
            
            
        }
        .onAppear{
            singlePlayerViwModel.calculateScore()
        }
    }
}

#Preview {
    ScoreView(singlePlayerViwModel: SinglePlayerSessionViewModel())
}
