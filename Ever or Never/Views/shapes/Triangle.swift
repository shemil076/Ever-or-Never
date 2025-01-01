//
//  Triangle.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-12-17.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
    
        let topPoint = CGPoint(x: rect.minX, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
    
        path.move(to: topPoint)
        path.addLine(to: bottomLeft)
        path.addLine(to: bottomRight)
        path.closeSubpath()
    
        return path
    }
//    func path(in rect: CGRect) -> Path {
//            var path = Path()
//            
//            // Define the 3 points of the triangle
//            let topPoint = CGPoint(x: rect.midX, y: rect.minY)       // Top center
//            let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)     // Bottom left
//            let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)    // Bottom right
//            
//            // Move to the top point and draw lines to the other points
//            path.move(to: topPoint)
//            path.addLine(to: bottomLeft)
//            path.addLine(to: bottomRight)
//            path.closeSubpath()
//            
//            return path
//        }
 }

#Preview { Triangle().rotation(.degrees(90)) }

//func path(in rect: CGRect) -> Path {
//    var path = Path()
//    
//    let topPoint = CGPoint(x: rect.minX, y: rect.minY)
//    let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
//    let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
//    
//    path.move(to: topPoint)
//    path.addLine(to: bottomLeft)
//    path.addLine(to: bottomRight)
//    path.closeSubpath()
//    
//    return path
//}
