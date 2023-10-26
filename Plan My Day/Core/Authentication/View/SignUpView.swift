//
//  SignUpView.swift
//  Plan My Day
//
//  Created by Itzel Villanueva on 10/25/23.
//

import SwiftUI

struct SignUpView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
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
                //fullName
                InputView(text: $fullName,
                          title: "Full Name",
                          placeholder: "Enter Your Name")
                //password
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter Password",
                          isSecureField: true)
                .autocapitalization(.none)
                //password x2
                InputView(text: $confirmPassword,
                          title: "Confirm Password",
                          placeholder: "Confirm Password",
                          isSecureField: true)
                .autocapitalization(.none)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            //sign in button
            Button{
                print("Sign User Up")
            }label: {
                HStack{
                    Text("Sign Up")
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
            
            Button{
                dismiss()
            }label: {
                HStack(spacing: 7){
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .font(.system(size:14))
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
