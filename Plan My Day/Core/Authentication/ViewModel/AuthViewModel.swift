//
//  AuthViewModel.swift
//  Plan My Day
//
//  Created by Alysha Kanjiyani on 10/25/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


protocol AuthenticationFormProtocol{
    var formIsValid: Bool{get}
}

@MainActor
class AuthViewModel: ObservableObject {
    //to see if user is logged in currently
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    @Published var signInError: String?
    @Published var signUpError: String?
    
    
    //will keep the user signed in
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task{
            await fetchUser()
        }
    }
    func signIn(withEmail email: String, password: String) async throws {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        }
        catch{
            signInError = "Failed to login: \(error.localizedDescription)"
            print("DEBUG: Failed to login \(error.localizedDescription)")
        }
    }
    //making the user when they sign up with new account
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            self.signUpError = "Sign-Up Unsuccessful: \(error.localizedDescription)"
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw error // Re-throw the error so it can be caught by the caller.
        }
    }
    func signOut(){
        do{
            //backend sign out
            try Auth.auth().signOut()
            //gets rid of the user data
            self.userSession = nil
            self.currentUser = nil
        }
        catch{
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(){
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else{return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else{return}
        self.currentUser = try? snapshot.data(as:User.self)
        
        //        print("DEBUG: Current user is \(self.currentUser)")
    }
}
