//
//  AuthViewModel.swift
//  BookingApp
//
//  Created by Mariana and Abigail on 21/02/2025.

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
       checkAuthState()
    }

    func checkAuthState() {
        if let currentUser = Auth.auth().currentUser {
            self.isAuthenticated = true
            self.userId = currentUser.uid
        }
    }
   
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else {
                self.isAuthenticated = true
                self.userId = (Auth.auth().currentUser?.uid) ?? ""

                Auth.auth().currentUser?.getIDToken(completion: { token, error in
                    if let token = token {
                        print("ID Token: \(token)")
                        self.sendTokenToBackend()

                    }
                })

                print(self.userId) //bruker empty
            }
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

    // La till den här nya funktionen för att hämta token för API anrop
    func getToken(completion: @escaping (String?) -> Void) {
        Auth.auth().currentUser?.getIDToken { token, error in
            if let error = error {
                print("Kunde inte hämta token: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(token)
        }
    }

    func sendTokenToBackend() {
        Auth.auth().currentUser?.getIDToken { token, error in
            guard let token = token else {
                print("Kunde inte få token: \(error?.localizedDescription ?? "Okänt fel")")
                return
            }

            var request = URLRequest(url: URL(string: "https://hytteportalen-307333592311.europe-west1.run.app/api/auth/login")!)
            request.httpMethod = "POST" //ändrat till post från GET.
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Nätverk fel: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Servern svarade med status: \(httpResponse.statusCode)")
                }
            }.resume()
        }
    }
}
