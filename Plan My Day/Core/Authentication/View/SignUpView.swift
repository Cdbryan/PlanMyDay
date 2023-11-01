//
//  SignUpView.swift
//  Plan My Day
//
//  Created by Itzel Villanueva on 10/25/23.
//

import SwiftUI
import Firebase

struct SignUpView: View {
    @State private var email = ""
    @State private var fullName = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isSignUpSuccessful = false
    @State private var showAlert = false
    @State private var alertMessage = "" // Store error message
    
    
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
                ZStack(alignment: .trailing){
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Confirm Password",
                              isSecureField: true)
                    if !password.isEmpty && !confirmPassword.isEmpty{
                        if password == confirmPassword{
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        }
                        else{
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            //sign up button
            Button {
                Task {
                    do {
                        try await viewModel.createUser(withEmail: email, password: password, fullname: fullName)
                        isSignUpSuccessful = true
                    } catch {
                        isSignUpSuccessful = false
                        alertMessage = (error as? AuthErrorCode)?.localizedDescription ?? "An error occurred."
                    }
                    showAlert = true
                }
            } label: {
                HStack {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            .alert(isPresented: $showAlert) {
                if isSignUpSuccessful {
                    return Alert(
                        title: Text("Sign-Up Successful"),
                        message: Text("Your account has been created."),
                        dismissButton: .default(Text("OK")) {
                            dismiss()
                        }
                    )
                } else if viewModel.signUpError != nil {
                    return Alert(
                        title: Text("Sign-Up Unsuccessful"),
                        message: Text(viewModel.signUpError!),
                        dismissButton: .default(Text("OK"))
                    )
                } else {
                    return Alert(
                        title: Text("Sign-Up Unsuccessful"),
                        message: Text("An error occurred."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
}

extension SignUpView:AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullName.isEmpty
    }
    
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}