//
//  ForgotPasswordView.swift
//  Plan My Day
//
//  Created by Alysha Kanjiyani on 10/31/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var securityQuestionAnswer = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isPasswordResetSuccessful = false
    @State private var showAlert = false
    @State private var alertMessage = "" // Store error message

    var body: some View {
        NavigationView { // Wrap the view in a NavigationView
            VStack {
                Text("Forgot Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.vertical, 32)

                InputView(text: $email, title: "Email", placeholder: "Enter Email")
                    .autocapitalization(.none)

                InputView(text: $securityQuestionAnswer, title: "Security Question", placeholder: "What city were you born in")

                Button {
                    Task {
                        do {
                            try await viewModel.resetPassword(forEmail: email, withSecurityAnswer: securityQuestionAnswer)
                            isPasswordResetSuccessful = true
                        } catch {
                            alertMessage = error.localizedDescription
                            isPasswordResetSuccessful = false
                        }
                        showAlert = true
                    }
                } label: {
                    HStack {
                        Text("Reset Password")
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

//                Button(action: {
//                    // Navigate back to the login screen or perform the desired action
//                    isPasswordResetSuccessful = false
//                    showAlert = false
//                }) {
//                    Text("Back to Login")
//                }
//                .foregroundColor(Color(.systemBlue))
//                .padding(.top, 16)
            }
        }
        .alert(isPresented: $showAlert) {
            if isPasswordResetSuccessful {
                return Alert(
                    title: Text("Password Reset Successful"),
                    message: Text("Check your email for instructions on how to reset your password"),
                    dismissButton: .default(Text("OK")) {
                        // Navigate back to the login screen or perform the desired action
                        isPasswordResetSuccessful = false
                        showAlert = false
                    }
                )
            } else {
                return Alert(
                    title: Text("Password Reset Unsuccessful"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }

    var formIsValid: Bool {
        return !email.isEmpty && !securityQuestionAnswer.isEmpty
    }
}
