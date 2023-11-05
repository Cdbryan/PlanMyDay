//
//  ForgotPasswordView.swift
//  Plan My Day
//
//  Created by Alysha Kanjiyani on 10/31/23.
//


import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isPasswordResetSuccessful = false
    @State private var showAlert = false
    @State private var alertMessage = "" // Store error message

    var body: some View {
        NavigationView {
            VStack {
                Text("Forgot Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.vertical, 32)

                InputView(text: $email, title: "Email", placeholder: "Enter Email")
                    .autocapitalization(.none)

                Button {
                    Task {
                        do {
                            try await viewModel.resetPassword(forEmail: email)
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
            }
        }
        .alert(isPresented: $showAlert) {
            if isPasswordResetSuccessful {
                return Alert(
                    title: Text("Password Reset Successful"),
                    message: Text("Check your email for instructions on how to reset your password"),
                    dismissButton: .default(Text("OK")) {
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
        return !email.isEmpty
    }
}
