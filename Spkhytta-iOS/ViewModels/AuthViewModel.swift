//  AuthViewModel.swift
//  BookingApp
//
// Created by Mariana and Abigail on 21/02/2025.
//
//
//TODO
// 1. hämta in en access token från Firebase --fixat
//2. sänd en bearer token till backend i header. detta ska inte göras i den här filen utan en API kall --fixat
// 3. backend verifierar att det är rätt användare
//4. ska vi spara token till andra dekar av appen? --fixat med getToken
//5. lägg till guard på login
//
// till danial. bör vi tex ha en auth manager för api request? ska lägga överallt när man gör kall till backend för att verifiera. --fixat
//
// send auth och personal detaljer om vem som bokar in header, resten ska skickas i body.
// send in JSON format? --fixat
//
//Phone number?? detta borde vara med i databasen.
//Delete email. ska bara sända token, säkerhet


import Foundation
import SwiftUI
import FirebaseAuth
import SwiftData

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isAuthenticated = false
    @Published var errorMessage = ""
    @Published var user: User? = nil

    let userStorage: UserStorage

    init(userStorage: UserStorage) {
        self.userStorage = userStorage
        checkAuthenticationState()
    }

    private func checkAuthenticationState() {
        if let currentUser = Auth.auth().currentUser {
            print("User already authenticated: \(currentUser.uid)")
            isAuthenticated = true

            if let storedUser = userStorage.fetchUser(byFirebaseId: currentUser.uid) {
                self.user = storedUser
                print("Loaded stored user: \(storedUser.name) with ID: \(storedUser.firebaseId)")
            } else {
                print("No stored user found for ID: \(currentUser.uid)")
                Task {
                    if let token = try? await currentUser.getIDToken() {
                        _ = await verifyWithBackend(token: token)
                    }
                }
            }
        }
    }

    func login() {
        Task {
            do {
                logout(clearAuth: false) // Rensar gammal användare innan ny inloggning

                print("Attempting login with email: \(email)")
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                print("Firebase login successful")
                print("FIREBASE UID: \(result.user.uid)")

                if let token = try? await result.user.getIDToken() {
                    print("FIREBASE TOKEN: \(token)")
                    TokenManager.shared.updateToken(token)
                    
                    // Wait for backend to verify and return user data before proceeding
                    if await verifyWithBackend(token: token) {
                        print("Backend verification successful, user data saved")
                        
                        // At this point, self.user should be set by verifyWithBackend
                        print("User data received from server: \(self.user?.name ?? "Not set")")
                        
                        // Now set authenticated state
                        self.isAuthenticated = true
                    } else {
                        print("Backend verification failed - user still logged in via Firebase")
                        // Set authenticated but notify about missing user data
                        self.isAuthenticated = true
                        self.errorMessage = "Connected but unable to fetch user details"
                    }
                } else {
                    print("Failed to get token, but user still authenticated via Firebase")
                    self.isAuthenticated = true
                    self.errorMessage = "Connected but unable to sync with server"
                }
            } catch {
                print("Firebase login error: \(error.localizedDescription)")
                self.errorMessage = "Login failed: \(error.localizedDescription)"
                self.isAuthenticated = false
            }
        }
    }

    func verifyWithBackend(token: String) async -> Bool {
        guard let url = URL(string: "http://127.0.0.1:5000/api/auth/login") else {
            print("Invalid URL for backend login")
            return false
        }

        print("Connecting to backend")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 15

        let payload: [String: Any] = [:]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            print("Failed to encode payload")
            return false
        }
        request.httpBody = jsonData

        do {
            print("Sending request to backend")
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Backend verification failed: Not an HTTP response")
                return false
            }

            print("Backend response code: \(httpResponse.statusCode)")

            if httpResponse.statusCode == 200 {
                do {
                    let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                    print("Successfully decoded auth response")

                    let user = User(
                        firebaseId: authResponse.firebaseUid,
                        email: authResponse.email,
                        name: authResponse.name,
                        isAdmin: authResponse.isAdmin ?? false
                    )

                    print("Saving user: \(user.name)")
                    userStorage.saveUser(user)
                    
                    // Important: Update the user property immediately
                    // This is the key part that ensures the user variable is set
                    self.user = user
                    print("User variable set with server data: \(user.name)")
                    
                    return true
                } catch {
                    print("Error decoding auth response: \(error)")
                    return false
                }
            } else {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Error response from backend: \(responseString)")
                }
                print("Backend verification failed: Status \(httpResponse.statusCode)")
                return false
            }
        } catch {
            print("Backend network error: \(error)")
            return false
        }
    }

    func logout(clearAuth: Bool = true) {
        if let current = user {
            userStorage.deleteUser(current) // Rensar användare från storage
        }

        user = nil
        TokenManager.shared.clearToken()
        isAuthenticated = false

        if clearAuth {
            do {
                try Auth.auth().signOut()
                print("User logged out from Firebase successfully")
            } catch {
                print("Error signing out from Firebase: \(error.localizedDescription)")
            }
        }
    }
}
