//
//  SignUpEmailView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-08.
//

import SwiftUI

@MainActor
final class SignUpEmailViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var displayName = ""
    @Published var dob = Date()
    
    func signUp() async throws{
        guard !email.isEmpty, !password.isEmpty else {
            print("Please enter email and password")
            return
        }
        
        let authDataResults = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResults, displayName: displayName, dob: dob)
        print(user)
        try await UserManager.shared.createNewUser(user: user)
    }
}
struct SignUpEmailView: View {
    @StateObject private var viewModel = SignUpEmailViewModel()
    @Binding var showSignInView : Bool
    var body: some View {
        VStack{
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            TextField("Display name...", text: $viewModel.displayName)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            HStack{
                Text("Select the date of birth")
                Spacer()
                DatePicker("Date of Birth", selection: $viewModel.dob, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    }catch {

                        print(error)
                    }
                    
                }
            } label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .navigationTitle("Sign Up")
        .padding()
    }
}

#Preview {
    NavigationStack{ SignUpEmailView(showSignInView: .constant(false))}
}
