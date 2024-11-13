//
//  MultiplayerLobbyView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-04.
//

import SwiftUI

struct MultiplayerLobbyView: View {
    var body: some View {
        @State var textInput: String = ""
        VStack{
            
            Button {
                
            } label: {
                Text("New Game")
            }

            HStack{
                Text("Join now:")
                TextField("Placeholder text", text: $textInput)
                               .textFieldStyle(RoundedBorderTextFieldStyle())
                               .padding()
//                               .border(Color.gray, width: 1)
                               .padding()
                
            }.padding()
            
           
        }
    }
}

#Preview {
    MultiplayerLobbyView()
}
