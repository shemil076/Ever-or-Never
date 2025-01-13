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
    @State private var dateOfBirth: String = ""
    @State private var displayName: String = ""
    @Binding var showSignInView : Bool
    @State var showAlert = false
    var body: some View {
        ZStack{
            ViewBackground()
                .ignoresSafeArea()
            
            
            
            VStack(alignment: .leading, spacing: 20){
                
                Text("User Information")
                    .font(.title)
                    .foregroundStyle(.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Display Name")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    
                    
                    ZStack(alignment: .leading) {
                        if viewModel.displayName.isEmpty {
                            Text("Enter the display name")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                        }
                        
                        TextField("", text: $viewModel.displayName)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .font(.body)
                            .foregroundColor(.white)
                    }
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    
                    
                    ZStack(alignment: .leading) {
                        if viewModel.email.isEmpty {
                            Text("Enter the email")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                        }
                        
                        TextField("", text: $viewModel.email)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .font(.body)
                            .foregroundColor(.white)
                    }
                }
                
                // Date of Birth Field with Calendar Button
                VStack(alignment: .leading, spacing: 4) {
                    Text("Date of Birth")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        TextField("DD/MM/YYYY", text: $dateOfBirth)
                            .padding()
                            .foregroundColor(.gray)
                            .font(.body)
                        
                        Button(action: {
                            // Handle calendar button action here
                        }) {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                                .padding()
                            
                            DatePicker("Date of Birth", selection: $viewModel.dob, in: ...Date(), displayedComponents: .date)
                                .foregroundColor(.white)
                                .datePickerStyle(.compact)
                                .labelsHidden()
                                .tint(.white)
                            
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Password")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    ZStack(alignment: .leading) {
                        if viewModel.password.isEmpty {
                            Text("Password")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                        }
                        
                        SecureField("", text: $viewModel.password)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                            .font(.body)
                            .foregroundColor(.white)
                    }
                    
                    
                }
                
                
                
                
                Button {
                    if !viewModel.password.isEmpty || !viewModel.email.isEmpty || !viewModel.displayName.isEmpty {
                        Task {
                            do {
                                try await viewModel.signUp()
                                showSignInView = false
                                return
                            }catch {
                                
                                print(error)
                            }
                            
                        }
                    } else {
                        showAlert = true
                    }
                } label: {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                        .cornerRadius(10)
                }
                .padding(.bottom , 20)
            }
            .padding()
        }
        .alert("Please fill the fields", isPresented: $showAlert){
            Button("OK"){
                showAlert = false
            }
        }
    }
}

#Preview {
    NavigationStack{ SignUpEmailView(showSignInView: .constant(false))}
}
