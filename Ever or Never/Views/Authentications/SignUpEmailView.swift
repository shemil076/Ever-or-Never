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
    var body: some View {
        ZStack{
            ViewBackground()
            
//            DualCircles()
            
            VStack(alignment: .leading, spacing: 20){
                
                Text("User Information")
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Display Name")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("Enter the display name", text: $viewModel.displayName)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .font(.body)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Email")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("Enter the email address", text: $viewModel.email)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .font(.body)
                }
                
                // Date of Birth Field with Calendar Button
                VStack(alignment: .leading, spacing: 4) {
                    Text("Date of Birth")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        TextField("DD/MM/YYYY", text: $dateOfBirth)
                            .padding()
                            .font(.body)
                        
                        Button(action: {
                            // Handle calendar button action here
                        }) {
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                                .padding()
                            
                            DatePicker("Date of Birth", selection: $viewModel.dob, in: ...Date(), displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .labelsHidden()
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
                    
                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .font(.body)
                }
                
//                                TextField("Email...", text: $viewModel.email)
//                                    .padding()
//                                    .background(Color.gray.opacity(0.4))
//                                    .cornerRadius(10)
//                                TextField("Display name...", text: $viewModel.displayName)
//                                    .padding()
//                                    .background(Color.gray.opacity(0.4))
//                                    .cornerRadius(10)
                
//                                HStack{
//                                    Text("Select the date of birth")
//                                    Spacer()
//                                    DatePicker("Date of Birth", selection: $viewModel.dob, in: ...Date(), displayedComponents: .date)
//                                        .datePickerStyle(.compact)
//                                        .labelsHidden()
//                                }
//                                SecureField("Password...", text: $viewModel.password)
//                                    .padding()
//                                    .background(Color.gray.opacity(0.4))
//                                    .cornerRadius(10)
                
                
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
                                        .background(Color(red: 78/255, green: 130/255, blue: 209/255))
                                        .cornerRadius(10)
                                }
                                .padding(.bottom , 20)
            }
            .padding()
        }
//        .ignoresSafeArea()
    }
}

#Preview {
    NavigationStack{ SignUpEmailView(showSignInView: .constant(false))}
}
