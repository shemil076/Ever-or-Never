//
//  ViewBackground.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-27.
//

import SwiftUI

struct ViewBackground: View {
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
        }
    }
}

#Preview {
    ViewBackground()
}
