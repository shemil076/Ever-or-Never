//
//  AuthenticationView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-06.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding var showSignInView: Bool
    var body: some View {
        VStack{
            NavigationLink{
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sign in with email")
                    .font(.headline)
            }.padding()
           
            VStack{
                Text("Don't have an account?")
                Text("no worries, sign up")
                NavigationLink{
                    SignUpEmailView(showSignInView: $showSignInView)
                } label: {
                    Text("Sign up with email")
                        .font(.headline)
                }.padding()
            }
            
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack { AuthenticationView(showSignInView: .constant(false)) }
}
