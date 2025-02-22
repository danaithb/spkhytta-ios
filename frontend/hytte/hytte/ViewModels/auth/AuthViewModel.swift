//
//  AuthViewModel.swift
//  BookingApp
//
//  Created by Mariana and Abigail on 21/02/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isAuthenticated = false
    @Published var userId = ""
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.isAuthenticated = true
                self.userId = (Auth.auth().currentUser?.uid)!
                print(self.userId)//log out user id ska bli reset till empty igen.
            }//user id till backend lägg till i db. gör api swiftUI. func send user id to bakckend, java backend kan requesta det api använd folder name. call function.
        }
    }
    //den här retunerar user id for API
    func getFirebaseUserId()-> String? {
        return (Auth.auth().currentUser?.uid)!
    }
}


