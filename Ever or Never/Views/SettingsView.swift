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
    @Binding var showSignInView: Bool
    var body: some View {
        List{
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
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack { SettingsView(showSignInView: .constant(false)) }
}
