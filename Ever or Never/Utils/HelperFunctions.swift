//
//  HelperFunctions.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-12-04.
//

import Foundation
import UIKit
import SwiftUI

class HelperFunctions{
    
    static func getUserFriendlyErrorMessage(stringError: String) -> String{
        switch stringError{
            case let msg where msg.contains("No document to update: "):
            return "Invalid ID provided"
        default:
            return stringError
        }
    }
    
    static func copyToClipboard(id: String, isCopied: Binding<Bool>) {
        UIPasteboard.general.string = "Use this session id to join: \n\n" + id + "\n\n"  + "Ever Ready, Never Bored – Let the Fun Begin! 🎉"
        isCopied.wrappedValue = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isCopied.wrappedValue = false
        }
    }

}
