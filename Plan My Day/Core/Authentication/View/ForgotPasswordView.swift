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
    @State private var navigateBackToLogin = false // New state variable

    
    var body: some View {
        NavigationStack{
            VStack {
                Image("sunset")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 270)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .overlay(Circle().stroke(Color("orange"), lineWidth: 4))
                    .shadow(radius: 4)
                    .padding(.top, -55)
                    .padding(.bottom, 20)
                
                Text("Forgot Password").accessibilityIdentifier("Forgot Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.vertical, 32)
                    .foregroundColor(Color("orange"))
                
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
                        Text("Reset Password").accessibilityIdentifier("Reset Password")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color("orange"))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
                .navigationBarBackButtonHidden(true)
                
            }
            Button(action: {
                               navigateBackToLogin = true
                           }) {
                               Text("Back to Login")
                                   .font(.system(size: 20))
                                   .bold()
                                   .padding(.top, 30)
                                   .foregroundColor(Color("orange"))
                           }
                           .background(NavigationLink("", destination: LoginView().navigationBarBackButtonHidden(true), isActive: $navigateBackToLogin))
                       }
                       .navigationBarBackButtonHidden(true) // Hide the default back button
                       .navigationBarItems(
                           trailing: EmptyView()
                       )
            

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
