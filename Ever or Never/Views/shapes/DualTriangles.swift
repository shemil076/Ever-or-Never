//
//  DualTriangles.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-12-17.
//

import SwiftUI

struct DualTriangles: View {
    var body: some View {
        ZStack{
            ZStack{
                
                HStack{
                    
                    Triangle()
                        
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 12 / 255.0, green: 27 / 255.0, blue: 44 / 255.0), Color(red: 10 / 255.0, green: 23 / 255.0, blue: 37 / 255.0).opacity(0.1)]), startPoint: .top, endPoint: .bottom
                            )
                        ).frame(width: UIScreen.main.bounds.height/3.5, height: UIScreen.main.bounds.width/1.4)
                        
                    
                    Spacer()
                }
                
                HStack{
                    Spacer()
                    Triangle()
                        
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 12 / 255.0, green: 27 / 255.0, blue: 44 / 255.0), Color(red: 10 / 255.0, green: 23 / 255.0, blue: 37 / 255.0).opacity(0.01)]), startPoint: .top, endPoint: .bottom
                            )
                        )
                        .frame(width: UIScreen.main.bounds.height/3.5, height: UIScreen.main.bounds.width/1.4)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        
                  }
            }
            .padding(.bottom, UIScreen.main.bounds.height/3)
            
            ZStack{
                
                HStack{
                    
                    Triangle()
                        
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 12 / 255.0, green: 27 / 255.0, blue: 44 / 255.0), Color(red: 10 / 255.0, green: 23 / 255.0, blue: 37 / 255.0).opacity(0.01)]), startPoint: .top, endPoint: .bottom
                            )
                        ).frame(width: UIScreen.main.bounds.height/3.5, height: UIScreen.main.bounds.width/1.5)
                        
                    
                    Spacer()
                }
                
                HStack{
                    Spacer()
                    Triangle()
                        
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(red: 12 / 255.0, green: 27 / 255.0, blue: 44 / 255.0), Color(red: 10 / 255.0, green: 23 / 255.0, blue: 37 / 255.0).opacity(0.1)]), startPoint: .top, endPoint: .bottom
                            )
                        )
                        .frame(width: UIScreen.main.bounds.height/3.5, height: UIScreen.main.bounds.width/1.5)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        
                  }
            }
        }
    }
}

#Preview {
    DualTriangles()
}
