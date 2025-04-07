//  AuthViewModel.swift
//  BookingApp
//
//  Created by Mariana and Abigail on 21/02/2025.
//ändra authID?
// TODO
// hämta in en access token från Firebase
// sänd en bearer token till backend i header. detta ska inte göras i den här filen utan en API kall
// backend verifierar att det är rätt användare
//ska vi spara token till andra dekar av appen?

//lägg till guard på login

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
    
    init() {
        // är användare redan inoggad?
        checkAuthState()
    }
    
    func checkAuthState() {
        if let currentUser = Auth.auth().currentUser {
            self.isAuthenticated = true
            self.userId = currentUser.uid
        }
    }
    //TODO lägg in hämta token här i funktionen.
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.isAuthenticated = true
                self.userId = (Auth.auth().currentUser?.uid) ?? ""// så den inte crashar om inte någon är inloggad. return empty string
                //hämta in token här.
                Auth.auth().currentUser?.getIDToken(completion: { token, error in
                    if let token = token {
                        print("ID Token: \(token)")
                        // Send this token to your backend (in a secure way)
                        self.sendTokenToBackend()
                    }
                })

                print(self.userId)//log out user id ska bli reset till empty igen.
            }//user id till backend lägg till i db. gör api swiftUI. func send user id to bakckend, java backend kan requesta det api använd folder name. call function.
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
            self.userId = ""
            self.email = ""
            self.password = ""
        } catch {
            self.errorMessage = "Error signing out"
        }
    }
    
    func sendTokenToBackend() {
        Auth.auth().currentUser?.getIDToken { token, error in
            guard let token = token else {
                print("Failed to get token: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            var request = URLRequest(url: URL(string: "http://localhost:8888 /api/secure-endpoint")!)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Server responded with status: \(httpResponse.statusCode)")
                }
            }.resume()
        }
    }

    
    //testat api som fungerar. ta bort denna till final code.
//    //den här retunerar user id for API
//    func getFirebaseUserId() -> String? {
//        return Auth.auth().currentUser?.uid
//    }
}


