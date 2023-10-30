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
    @EnvironmentObject var viewModel : AuthViewModel
    @State private var isSignInSuccessful = false
    @State private var navigateToProfile = false // New state variable

    
    var body: some View {
        NavigationStack{
            NavigationView{
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
                    // Sign in button
                    Button {
                        Task {
                            do {
                                try await viewModel.signIn(withEmail: email, password: password)
                                isSignInSuccessful = true
                            } catch {
                                print("Error: \(error)")
                            }
                            
                            if isSignInSuccessful {
                                navigateToProfile = true // Set the flag to navigate
                            }
                        }
                    } label: {
                        HStack {
                            Text("Sign In")
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
                    
                    Spacer()
                    
                    // Sign up button
                    NavigationLink(
                        destination: SignUpView().navigationBarBackButtonHidden(true),
                        label: {
                            HStack(spacing: 7) {
                                Text("Don't have an account?")
                                Text("Sign Up")
                                    .fontWeight(.bold)
                            }
                            .font(.system(size: 14))
                        }
                    )
                }
            }
            .background(
                NavigationLink(
                    destination: ProfileView().navigationBarBackButtonHidden(true),
                    isActive: $navigateToProfile,
                    label: { EmptyView() }
                )
            )
        }
    }
  }

extension LoginView:AuthenticationFormProtocol{
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
    
    
}

@available(iOS 16.0, *)
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
