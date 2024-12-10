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
    
    @StateObject var networkMonitor = NetworkMonitor()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
   

    
    
    //    @StateObject private var multiPlayerSessionViewModel = MultiplayerSessionViewModel()
    
    
    
    var body: some Scene {
        WindowGroup {
            if networkMonitor.isConnected{
                NavigationStack{
                    //                AuthenticationView()
                    ContentView()
                      
                        
                    //                    .environmentObject(AppDependancyContainer.shared.multiGameSessionViewModel)
                }
            }else{
                NoConnectionView()
            }
        }
    }
    

}

//    init(){
//        FirebaseApp.configure()
//        print("Firebase App Configured")
//    }


struct NoConnectionView: View {
    var body: some View {
        VStack {
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            Text("No Internet Connection")
                .font(.title)
                .padding()
        }
    }
}
