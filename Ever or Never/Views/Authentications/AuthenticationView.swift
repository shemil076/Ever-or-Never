//
//  AuthenticationView.swift
//  Ever or Never
//
//  Created by Pramuditha Karunarathna on 2024-11-06.
//

import SwiftUI

struct AuthenticationView: View {
    @Binding var showSignInView: Bool
    
    var screenSize = UIScreen.main.bounds
    var body: some View {
        ZStack {
            // Add a Linear Gradient background
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color.white, location: 0.0),   // Blue starts at the top
                    .init(color: Color.blue.opacity(0.3), location: 1.0) // Purple starts lower (60% of the view height)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            
            VStack {
                VStack{
                    HStack{
                        Image("emoji-orange")
                        Spacer()
                        Image("emoji-green")


                    }
                    
                    HStack{
                        Image("emoji-blue")
                        Spacer()

                        Image("emoji-yellow")


            
                    }
//                    .frame(height:  UIScreen.main.bounds.height / 4 )
                }
//                .padding(.top,UIScreen.main.bounds.height / 6)
                
//                Spacer()
                            
                VStack(spacing: 10){
                    Text("Ever or Never")
                        .font(.custom("Montserrat-Black", size: UIFont.preferredFont(forTextStyle: .extraLargeTitle).pointSize))
                        .foregroundColor(Color(red: 78/255, green: 130/255, blue: 209/255))
                    
                    Text("Hello Welcome!")
                }
                .padding(.bottom, UIScreen.main.bounds.height / 13)
                
                VStack (spacing: 20){

                    NavigationLink {
                        SignInEmailView(showSignInView: $showSignInView)
                    } label: {
                        Text("Sign in with email")
                            .frame(width:UIScreen.main.bounds.width / 1.4)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                    }
                    
                    NavigationLink {
                        SignUpEmailView(showSignInView: $showSignInView)
                    } label: {
                        Text("Sign up with email")
                            .frame(width:UIScreen.main.bounds.width / 1.4)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                    }
                }
                .padding(.bottom, UIScreen.main.bounds.height / 7)
            }
        }
//        .ignoresSafeArea()
    }
}


#Preview {
    NavigationStack { AuthenticationView(showSignInView: .constant(false)) }
}
