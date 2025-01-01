//
//  ViewTest.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-29.
//

import SwiftUI

struct ViewTest: View {
    @State private var progress: Double = 0.5
    var body: some View {
        ZStack{
            ViewBackground()
            
            VStack{
//                VStack(spacing: 20) {
                    ProgressView(value: progress) {
                        Text("Loading...")
                            .foregroundStyle(.white)
                    }
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 200, height: 10)
//
                    Slider(value: $progress, in: 0.0...1.0) // Adjust progress with a slider
                        .padding()
//                }
//                .padding()
                
                
//                VStack(spacing: 20) {
//                           ProgressView(value: progress)
//                               .progressViewStyle(CircularProgressViewStyle())
//
//                           Button("Increase Progress") {
//                               if progress < 1.0 {
//                                   progress += 0.1
//                               }
//                           }
//                       }
//                       .padding()
                
                
                
                VStack {
                           ZStack(alignment: .leading) {
                               Rectangle()
                                   .frame(height: 10)
                                   .cornerRadius(10)
                                   .foregroundColor(Color.gray.opacity(0.3))
                               
                               Rectangle()
                                   .frame(width: progress * 300, height: 10)
                                   .cornerRadius(10)
                                   .foregroundColor(.blue)
                                   .animation(.easeInOut, value: progress)
                           }
                           .frame(width: 300)
                    
                    Text("Progress: \(progress)")
                        .foregroundStyle(.white)

                           Button("Increase Progress") {
                               if progress < 1.0 {
                                   progress += 0.1
                               }
                           }
                       }
                       .padding()

            }
            
            
        }
    }
}

#Preview {
    ViewTest()
}

