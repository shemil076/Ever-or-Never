//
//  ContinueButton.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2025-01-13.
//

import SwiftUI


struct ContinueButton : View {
    var isLoading: Bool
    var isDisabled: Bool
    var action:() -> Void
    
    var body : some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                    .cornerRadius(10)
            } else{
                
                Text("CONTINUE")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                    .cornerRadius(10)
            }
        }
        .disabled(isDisabled)
        .padding(.horizontal, 20)
        .accessibilityLabel("Continue Button")
        .accessibilityHint("Proceeds to the next screen when enabled")
    }
}

#Preview {
    ContinueButton(
        isLoading: false,
        isDisabled: false,
        action: {
            print("Continue button tapped")
        }
    )
}
