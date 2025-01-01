//
//  DualCircles.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-12-18.
//

import SwiftUI

struct DualCircles: View {
    var body: some View {
        ZStack{
//            Circle()
//                .fill(.white.opacity(0.02))
//            
//            
//            Circle()
//                .fill(.white.opacity(0.04))
//                .frame(width: UIScreen.main.bounds.width / 1.2)
            
            
            
            
            Circle()
//                .fill(.white.opacity(0.02))
                .fill(.black)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                        .clipShape(Rectangle().offset(y: UIScreen.main.bounds.width / 5))
            
            
            Circle()
//                .fill(.white.opacity(0.04))
                .fill(.blue)
                .frame(width: UIScreen.main.bounds.width / 1.2, height: UIScreen.main.bounds.width / 1.2)
                        .clipShape(Rectangle().offset(y: UIScreen.main.bounds.width / 5))
        }
    }
}

#Preview {
    DualCircles()
}
