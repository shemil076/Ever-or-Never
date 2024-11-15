//
//  ContentView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-10-30.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSignInView: Bool = false
    
    
    
    
    var body: some View {
        ZStack{
            NavigationStack{
//                Text("Nothing here yet, trying to populate the DB")
//                ProfileView(showSignInView: $showSignInView)
                GameModeSelectionView(showSignInView: $showSignInView)
//                SettingsView(showSignInView: $showSignInView)
            }
        }
        .onAppear{
//            let _ = try? QuestionsManager.shared.populateQuestionsCollection()
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInView = authUser == nil 
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack{
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}

#Preview {
    ContentView()
}
