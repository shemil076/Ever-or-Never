//
//  Ever_or_NeverApp.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-10-30.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    print("Firebase App Configured")
    return true
  }
}

@main
struct Ever_or_NeverApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    @StateObject private var multiPlayerSessionViewModel = MultiplayerSessionViewModel()


    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
//                AuthenticationView()
                ContentView()
//                    .environmentObject(AppDependancyContainer.shared.multiGameSessionViewModel)
            }
        }
    }
}

//    init(){
//        FirebaseApp.configure()
//        print("Firebase App Configured")
//    }
