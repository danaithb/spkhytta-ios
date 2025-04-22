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
//


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
                        _ = await loginWithBackend(token: token)
                    }
                }
            }
        }
    }

    func login() {
        Task {
            do {
                logout(clearAuth: false) // 🧹 rensar gammal användare innan ny inloggning

                print("Attempting login with email: \(email)")
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                print("Firebase login successful")
                print("FULL FIREBASE UID: \(result.user.uid)")

                if let token = try? await result.user.getIDToken() {
                    print("FULL FIREBASE TOKEN: \(token)")
                    TokenManager.shared.updateToken(token)

                    if await loginWithBackend(token: token) {
                        isAuthenticated = true
                        print("Authentication complete, isAuthenticated: \(isAuthenticated)")
                    } else {
                        print("Backend login failed - authentication not completed")
                        errorMessage = "Could not authenticate with server. Please try again later."
                    }
                } else {
                    print("Failed to get token")
                    errorMessage = "Failed to get authentication token"
                }
            } catch {
                print("Login error: \(error.localizedDescription)")
                errorMessage = "Login failed: \(error.localizedDescription)"
                isAuthenticated = false
            }
        }
    }

    func loginWithBackend(token: String) async -> Bool {
        guard let url = URL(string: "http://127.0.0.1:5000/api/auth/login") else {
            print("Invalid URL for backend login")
            return false
        }

        print("Connecting to backend at: \(url.absoluteString)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 15

        let payload: [String: Any] = [
            "firebaseToken": token,
            "email": self.email // ✅ skickar e-post till backend så rätt användare hämtas
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            print("Failed to encode token payload")
            return false
        }

        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Sending payload: \(jsonString)")
        }

        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Backend login failed: Not an HTTP response")
                return false
            }

            print("Backend login response code: \(httpResponse.statusCode)")
            print("Response headers: \(httpResponse.allHeaderFields)")

            if let responseString = String(data: data, encoding: .utf8) {
                print("Response data: \(responseString)")
            }

            if httpResponse.statusCode == 200 {
                do {
                    let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)

                    let user = User(
                        firebaseId: authResponse.firebaseUid,
                        email: authResponse.email,
                        name: authResponse.name,
                        isAdmin: authResponse.isAdmin ?? false
                    )

                    print("Saving user: \(user.name) with firebaseId: \(user.firebaseId)")
                    userStorage.saveUser(user)

                    await MainActor.run {
                        self.user = user
                    }

                    return true
                } catch {
                    print("Error decoding auth response: \(error)")
                    return false
                }
            } else {
                if let responseString = String(data: data, encoding: .utf8) {
                    print("Error response from backend: \(responseString)")
                }
                print("Backend login failed: Status code \(httpResponse.statusCode)")
                return false
            }
        } catch {
            print("Backend login network error: \(error)")
            return false
        }
    }

    func logout(clearAuth: Bool = true) {
        if let current = user {
            userStorage.deleteUser(current) // ✅ rensar användare från storage
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
