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
                    .init(color: Color(red: 16 / 255.0, green: 36 / 255.0, blue: 58 / 255.0), location: 0.0),
                    
                    
                    .init(color: Color(red: 10 / 255.0, green: 23 / 255.0, blue: 37 / 255.0), location: 1.0) // Purple starts lower (60% of the view height)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
//            .ignoresSafeArea()
            
            VStack{
                VStack{
//                    Spacer()
                    ZStack{
                        DualTriangles()
                            .padding(.bottom, UIScreen.main.bounds.height/4)
//                        DualTriangles()
                    }
                }.padding(.top, UIScreen.main.bounds.height/7)
                
//                .background(Color.white)
                Spacer()
            }
            
            
//            VStack{
//                Spacer()
//                HStack{
//                    Image("bg-girl")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: UIScreen.main.bounds.width / 1.8)
//                    Spacer()
//                }
//            }
        }
    }
}

#Preview {
    ViewBackground()
}
