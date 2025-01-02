//
//  ProfileView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-07.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    static let shared = ProfileViewModel()

    @Published private(set) var user: DBUser? = nil
   
    
    func loadCurrentUser() async throws {
        let authDataResult = try  AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(id: authDataResult.uid)
    }
    
    func togglePremiumStatus()async throws{
        guard let user else { return }
        let currentPremiumStatus = user.isPremium
        
        Task{
            try await UserManager.shared.updateUserPremiumStatus(id: user.id, isPremium: !currentPremiumStatus)
            self.user = try await UserManager.shared.getUser(id: user.id)
        }
        
    }
}

struct ProfileView: View {
    
    @StateObject var profileViewModel = ProfileViewModel.shared
    @Binding var showSignInView : Bool
    var body: some View {
        List{
             if let user = profileViewModel.user {
                 Text("UserId: \(user.id)")
                 Text("Email: \(String(describing: user.email))")
                 Text("profile created date: \(String(describing: user.dateCreated))")
                 
                 Button{
                     Task{
                         try? await profileViewModel.togglePremiumStatus()
                     }
                 } label: {
                     Text("User is premium \((user.isPremium).description.capitalized)")
                 }
            }
            
          
        }
        .task{
            try? await profileViewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    NavigationLink{ 
                        SettingsView(showSignInView: $showSignInView)
                    } label: {
                        Image(systemName: "gear")
                            .font(.headline)
                    }
                }
            }
    }
}

#Preview {
    NavigationStack { ProfileView(showSignInView: .constant(false)) }
}
