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
                    .init(color: Color(red: 16 / 255.0, green: 36 / 255.0, blue: 58 / 255.0), location: 0.0),
                    
                    
                    .init(color: Color(red: 10 / 255.0, green: 23 / 255.0, blue: 37 / 255.0), location: 1.0) // Purple starts lower (60% of the view height)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            
            VStack {
                ZStack{
                    Image("Ellipse-min")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width)
                    
                    Image("group-logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.top, UIScreen.main.bounds.height/10)
                }
             
                            
                VStack(spacing: 10){
                    Text("Ever or Never")
                        .font(.custom("Montserrat-Black", size: UIFont.preferredFont(forTextStyle: .extraLargeTitle).pointSize))
                        .foregroundColor(.white)
                    
                    Text("Hello Welcome!")
                        .foregroundColor(.white)
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
