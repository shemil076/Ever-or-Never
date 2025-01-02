//
//  SettingsView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-07.
//

import SwiftUI

@MainActor
final class SettingsViewModel : ObservableObject {
    
    func signOut() throws{
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws{
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func deleteAccount() async throws{        
        try await AuthenticationManager.shared.deleteUser()
    }
}

struct SettingsView: View {
    
    @StateObject private var settingsViewModel = SettingsViewModel()
    @StateObject var profileViewModel = ProfileViewModel.shared
    @Binding var showSignInView: Bool
    var body: some View {
        List{
            Section(header: Text("Profile")){
                
                if let user = profileViewModel.user {
                    
                    HStack(spacing: 50){
                        Image("user")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading){
                            Text(user.displayName)
                                .font(.headline)
                            Text(user.id)
                        }
                    }
                }
            }
            Button("Log out"){
                Task{
                    do {
                        try settingsViewModel.signOut()
                        showSignInView = true
                    } catch {
                        
                    }
                }
            }
            Button(role: .destructive) {
                Task{
                    do {
                        try await settingsViewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        
                    }
                }
            } label: {
                Text("Delete Account")
            }
            
            
            Button("Reset Password"){
                Task{
                    do {
                        try await settingsViewModel.resetPassword ()
                        print("Password reset")
                    } catch {
                        
                    }
                }
            }
        }
        .background(
            ViewBackground()
                .ignoresSafeArea()
        )
        .scrollContentBackground(.hidden)
        .navigationTitle("Settings")
        .onAppear{
            Task{
                try! await profileViewModel.loadCurrentUser()
            }
        }
    }
}


#Preview {
    NavigationStack { SettingsView(showSignInView: .constant(false)) }
}
