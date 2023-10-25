//
//  LoginView.swift
//  Plan My Day
//
//  Created by Itzel Villanueva on 10/25/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        NavigationStack{
            VStack{
                //image
                Image("messi")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .padding(.vertical, 32)
                
                //input fields
                VStack(spacing: 24){
                    //email
                    InputView(text: $email,
                              title: "Email",
                              placeholder: "tommyT11@usc.edu")
                    .autocapitalization(.none)
                    //password
                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter Password",
                              isSecureField: true)
                    .autocapitalization(.none)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                
                //sign in button
                Button{
                    print("Log User In")
                }label: {
                    HStack{
                        Text("Sign In")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width-32, height:48)
                }
                .background(Color(.systemBlue))
                .cornerRadius(10)
                .padding(.top, 24)
                
                Spacer()
                
                //sign up button
                NavigationLink{
                    SignUpView()
                        .navigationBarBackButtonHidden(true)
                }label:{
                    HStack(spacing: 7){
                        Text("Don't have an account?")
                        Text("Sign Up")
                            .fontWeight(.bold)
                    }
                    .font(.system(size:14))
                }
            }
        }
    }
}

@available(iOS 16.0, *)
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
