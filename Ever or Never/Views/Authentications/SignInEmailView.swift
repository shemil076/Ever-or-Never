////
////  SignInEmailView.swift
////  Ever or Never
////
////  Created by Pramuditha Karunarathna on 2024-11-05.
////
//
import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    
    
    func signIn() async throws{
        guard !email.isEmpty, !password.isEmpty else {
            print("Please enter email and password")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
}


struct SignInEmailView: View {
    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView : Bool
    @State private var showAlert: Bool = false
    var body: some View {
        ZStack{
            
            ViewBackground()
            

            
            VStack{
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    TextField("Enter the display name", text: $viewModel.email)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .font(.body)
                        .foregroundColor(.white)
                }

//                TextField("Email...", text: $viewModel.email)
//                    .padding()
//                    .background(Color.gray.opacity(0.4))
//                    .cornerRadius(10)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Password")
                        .font(.caption)
                        .foregroundColor(.white)
                        .foregroundColor(.white)
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .font(.body)
                        .foregroundColor(.white)
                }
//
//                SecureField("Password...", text: $viewModel.password)
//                    .padding()
//                    .background(Color.gray.opacity(0.4))
//                    .cornerRadius(10)
                
                Button {
                    Task {
                        
                        do {
                            try await viewModel.signIn()
                            showSignInView = false
                            return
                        }catch {
                            print(error)
                            print("Please register first")
                            showAlert = true
                        }
                    }
                } label: {
                    Text("Sign in")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                        .cornerRadius(10)
                }
            }
            .alert("Please register first", isPresented: $showAlert){
                Button("OK"){
                    showAlert = false
                }
            }
            .padding()
            }
//        .ignoresSafeArea()
    }
}

#Preview {
    NavigationStack{
        SignInEmailView(showSignInView: .constant(false))
    }
}
