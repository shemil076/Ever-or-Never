//
//  ViewTest.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-29.
//

import SwiftUI

struct ViewTest: View {
    var body: some View {
        ZStack{
            ViewBackground()
            
//            ZStack{
//                Rectangle()
//                    .fill(Color(red: 187 / 255.0, green: 209 / 255.0, blue: 243 / 255.0))
//                    .frame(width: UIScreen.main.bounds.width / 1.37, height: UIScreen.main.bounds.height / 1.5)
//                    .cornerRadius(20)
//                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 5)
//                    .offset(y: 20)
//                Rectangle()
//                    .fill(Color(red: 212 / 255.0, green: 227 / 255.0, blue: 249 / 255.0))
//                    .frame(width: UIScreen.main.bounds.width / 1.27, height: UIScreen.main.bounds.height / 1.5)
//                    .cornerRadius(20)
//                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 5)
//                    .offset(y: 10)
//                Rectangle()
//                    .fill(.white)
//                    .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.height / 1.5)
//                    .cornerRadius(20)
//                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 5)
//                
//                VStack{
//                    HStack{
//                        Text("Select an answer")
//                            .multilineTextAlignment(.leading)
//                            .foregroundColor(.gray)
//                            .fontWeight(.semibold)
//                        Spacer()
//                    }
//                    .padding(20)
//                    
//                    
//                    Text("This is a placeholder for the question and these characters are only for testing the layout of the view.")
//                        .multilineTextAlignment(.leading)
//                        .font(.title)
//                    
//                   
//                    VStack(spacing: 30){
//                        Button {
//                        
//                        } label: {
//                            Text("Yes")
//                                .font(.headline)
//                                .foregroundStyle(.white)
//                                .frame(height: 60)
//                                .frame(maxWidth: .infinity)
//                                .background(Color(red: 78/255, green: 130/255, blue: 209/255))
//                                .cornerRadius(20)
//                        }
//                        
//                        Button {
//                        
//                        } label: {
//                            Text("No")
//                                .font(.headline)
//                                .foregroundStyle(.black)
//                                .frame(height: 60)
//                                .frame(maxWidth: .infinity)
//                                .background(Color(red: 237 / 255.0, green: 239 / 255.0, blue: 240 / 255.0))
//                                .cornerRadius(20)
//                        }
//                    }.padding(20)
//
//                    
//                    Text("1 of 10 Questions")
//                        .foregroundColor(.gray)
//                        
//                }
//                .padding(20)
//                
//                
//            }
//            .padding(20)
            
            
            VStack{
                HStack {
                    // Display rank
                    Text("#1")
                        .foregroundColor(.black)
                        .padding(.leading, 20)

                    Spacer()

                    // Display user display name
                    Text("Player name")
                        .foregroundColor(.black)

                    Spacer()

                    // Display score
                    Text("\(50)")
                        .foregroundColor(.black)
                        .padding(.trailing, 20)
                }
                .frame(height: 60) // Frame for HStack
                .background(Color(red: 183 / 255, green: 207 / 255, blue: 241 / 255))
                .cornerRadius(15)
                .padding(.horizontal,20) // Optional padding for spacing
                .overlay{
                    if true {
                        Image("cup")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .rotationEffect(Angle(degrees: -10))
                            .offset(x: -UIScreen.main.bounds.width / 2.2)
                    }
                }
            }
        }
    }
}

#Preview {
    ViewTest()
}
