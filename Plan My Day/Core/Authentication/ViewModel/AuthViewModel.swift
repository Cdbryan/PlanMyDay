//
//  AuthViewModel.swift
//  Plan My Day
//
//  Created by Alysha Kanjiyani on 10/25/23.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    //to see if user is logged in currently
    @Published var UserSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init(){
        
    }
    func signIn(withEmail email: String, password: String) async throws {
    
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws{
    
    }
    
    func signOut(){
        
    }
    
    func deleteAccount(){
        
    }
    
    func fetchUser() async {
        
    }
}
