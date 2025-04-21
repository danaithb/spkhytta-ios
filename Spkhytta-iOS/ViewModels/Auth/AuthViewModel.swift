//  AuthViewModel.swift
//  BookingApp
//
//  Created by Mariana and Abigail on 21/02/2025.
//

// TODO
// 1. hämta in en access token från Firebase --fixat
// 2. sänd en bearer token till backend i header. detta ska inte göras i den här filen utan en API kall --fixat
// 3. backend verifierar att det är rätt användare
// 4. ska vi spara token till andra dekar av appen? --fixat med getToken
// 5. lägg till guard på login

// till danial. bör vi tex ha en auth manager för api request? ska lägga överallt när man gör kall till backend för att verifiera. --fixat

// send auth och personal detaljer om vem som bokar in header, resten ska skickas i body.
// send in JSON format? --fixat

//Phone number?? detta borde vara med i databasen.

//import SwiftUI
//import Firebase
//import FirebaseAuth
//import FirebaseCore
//
//class AuthViewModel: ObservableObject {
//    @Published var email = ""
//    @Published var password = ""
//    @Published var errorMessage = ""
//    @Published var isAuthenticated = false
//    @Published var userId = ""
//    
//    init() {
//        // är användare redan inoggad?
//        checkAuthState()
//    }
//    
//    func checkAuthState() {
//        if let currentUser = Auth.auth().currentUser {
//            self.isAuthenticated = true
//            self.userId = currentUser.uid
//        }
//    }
//    //lägg till en guard här
//    func login() {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                self.errorMessage = error.localizedDescription
//            } else {
//                self.isAuthenticated = true
//                self.userId = (Auth.auth().currentUser?.uid) ?? "" // så den inte crashar om inte någon är inloggad. return empty string
//                
//                Auth.auth().currentUser?.getIDToken(completion: { token, error in
//                    if let token = token {
//                        print("ID Token: \(token)")
//                        // skicka säkert till backend.
//                        self.sendTokenToBackend()
//                    }
//                })
//
//                print(self.userId) //log out user id ska bli reset till empty igen.
//            } //user id till backend lägg till i db. gör api swiftUI. func send user id to bakckend, java backend kan requesta det api använd folder name. call function.
//        }
//    }
//    
//    func logout() {
//        do {
//            try Auth.auth().signOut()
//            self.isAuthenticated = false
//            self.userId = ""
//            self.email = ""
//            self.password = ""
//        } catch {
//            self.errorMessage = "Error signing out"
//        }
//    }
//    
//    // La till den här nya funktionen för att hämta token för API anrop
//    func getToken(completion: @escaping (String?) -> Void) {
//        Auth.auth().currentUser?.getIDToken { token, error in
//            if let error = error {
//                print("Kunde inte hämta token: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//            completion(token)
//        }
//    }
//    
//    func sendTokenToBackend() {
//        Auth.auth().currentUser?.getIDToken { token, error in
//            guard let token = token else {
//                print("Kunde inte få token: \(error?.localizedDescription ?? "Okänt fel")")
//                return
//            }
//
//            var request = URLRequest(url: URL(string: "https://8514654f-9b3f-452a-921b-b5d95dcb862b.mock.pstmn.io/auth")!)
//            request.httpMethod = "POST" //ändrat till post från GET.
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print("Nätverk fel: \(error.localizedDescription)")
//                    return
//                }
//
//                if let httpResponse = response as? HTTPURLResponse {
//                    print("Servern svarade med status: \(httpResponse.statusCode)")
//                }
//            }.resume()
//        }
//    }
//}
//import SwiftUI
//import Firebase
//import FirebaseAuth
//import FirebaseCore
//
//class AuthViewModel: ObservableObject {
//    // Helper funktion för att göra namn med stor bokstav från epost
//    private func capitalizeNameFromEmail(_ email: String) -> String {
//        // Dela upp epost i username och domän delar
//        let emailComponents = email.components(separatedBy: "@")
//        guard let username = emailComponents.first else { return email }
//        
//        // Dela upp username vid punkter (för förnamn.efternamn format)
//        let nameComponents = username.components(separatedBy: ".")
//        
//        // Göra första bokstav i varje del stor
//        let capitalizedComponents = nameComponents.map { component -> String in
//            guard !component.isEmpty else { return component }
//            return component.prefix(1).uppercased() + component.dropFirst()
//        }
//        
//        // Sätt ihop med punkter
//        return capitalizedComponents.joined(separator: ".")
//    }
//    @Published var email = ""
//    @Published var password = ""
//    @Published var errorMessage = ""
//    @Published var isAuthenticated = false
//    @Published var userId = ""
//    @Published var userName = "" // Här lagras eposten som användarnamn
//    
//    init() {
//        checkAuthState()
//    }
//    
//    func checkAuthState() {
//        if let currentUser = Auth.auth().currentUser {
//            self.isAuthenticated = true
//            self.userId = currentUser.uid
//            if let email = currentUser.email {
//                self.userName = capitalizeNameFromEmail(email)
//            }
//        }
//    }
//    
//    func login() {
//        Auth.auth().signIn(withEmail: email, password: password) { result, error in
//            if let error = error {
//                self.errorMessage = error.localizedDescription
//            } else {
//                self.isAuthenticated = true
//                self.userId = (Auth.auth().currentUser?.uid) ?? ""
//                print("Firebase ID: \(self.userId)")
//                
//                Auth.auth().currentUser?.getIDToken(completion: { token, error in
//                    if let token = token {
//                        print("ID Token: \(token)")
//                        self.loginWithBackend(token: token)
//                    }
//                })
//            }
//        }
//    }
//    
//    func logout() {
//        do {
//            try Auth.auth().signOut()
//            self.isAuthenticated = false
//            self.userId = ""
//            self.email = ""
//            self.password = ""
//            self.userName = ""
//        } catch {
//            self.errorMessage = "Error signing out"
//        }
//    }
//    
//    func getToken(completion: @escaping (String?) -> Void) {
//        Auth.auth().currentUser?.getIDToken { token, error in
//            if let error = error {
//                print("Kunde inte hämta token: \(error.localizedDescription)")
//                completion(nil)
//                return
//            }
//            completion(token)
//        }
//    }
//    
//    func loginWithBackend(token: String) {
//        let authRequest = ["firebaseToken": token]
//        
//        guard let jsonData = try? JSONSerialization.data(withJSONObject: authRequest) else {
//            print("Kunde inte skapa JSON data")
//            return
//        }
//        
//        guard let url = URL(string: "http://127.0.0.1:5000/api/auth/login") else {
//            print("Ogiltig URL")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        request.httpBody = jsonData
//        
//        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            guard let self = self else { return }
//            
//            if let error = error {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Nätverk fel: \(error.localizedDescription)"
//                }
//                return
//            }
//            
//            if let httpResponse = response as? HTTPURLResponse {
//                print("Servern svarade med status: \(httpResponse.statusCode)")
//                
//                if httpResponse.statusCode != 200 {
//                    DispatchQueue.main.async {
//                        self.errorMessage = "Server svarade med felkod: \(httpResponse.statusCode)"
//                    }
//                    return
//                }
//            }
//            
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Ingen data mottagen från servern"
//                }
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let authResponse = try decoder.decode(AuthResponse.self, from: data)
//                
//                DispatchQueue.main.async {
//                    self.userName = self.capitalizeNameFromEmail(authResponse.email)
//                    print("Användare inloggad: \(authResponse.name), Email: \(authResponse.email)")
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    self.errorMessage = "Kunde inte tolka serverns svar: \(error.localizedDescription)"
//                }
//            }
//        }.resume()
//    }
//}
//
//  AuthViewModel.swift
//  hytte
//
//  Created by Mariana and Abigail on 01/04/2025.
//

//
//  AuthViewModel.swift
//  hytte
//
//  Created by Mariana and Abigail on 01/04/2025.
//

//
//  AuthViewModel.swift
//  hytte
//
//  Created by Mariana and Abigail on 01/04/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore

@MainActor
class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var isAuthenticated = false
    @Published var userId = ""
    @Published var userName = ""
    
    let userStorage = UserStorage()
    
    init() {
        checkAuthState()
    }
    
    func checkAuthState() {
        if let currentUser = Auth.auth().currentUser {
            self.isAuthenticated = true
            self.userId = currentUser.uid
            if let email = currentUser.email {
                self.userName = email
                // Spara användardata i SwiftData
                userStorage.saveUser(userId: currentUser.uid, email: email)
            }
        }
    }
    
    func login() {
        Task {
            do {
                let result = try await Auth.auth().signIn(withEmail: email, password: password)
                self.isAuthenticated = true
                self.userId = result.user.uid
                print("Firebase ID: \(self.userId)")
                
                if let email = result.user.email {
                    self.userName = email
                    // Spara användardata
                    userStorage.saveUser(userId: result.user.uid, email: email)
                }
                
                if let token = try? await result.user.getIDToken() {
                    print("ID Token: \(token)")
                    await loginWithBackend(token: token)
                }
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func logout() {
        do {
            // Ta bort användardata från SwiftData vid utloggning
            userStorage.deleteUser(userId: self.userId)
            
            try Auth.auth().signOut()
            self.isAuthenticated = false
            self.userId = ""
            self.email = ""
            self.password = ""
            self.userName = ""
        } catch {
            self.errorMessage = "Error signing out"
        }
    }
    
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
    
    func loginWithBackend(token: String) async {
        let authRequest = ["firebaseToken": token]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: authRequest) else {
            print("Kunde inte skapa JSON data")
            return
        }
        
        guard let url = URL(string: "http://127.0.0.1:5000/api/auth/login") else {
            print("Ogiltig URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Servern svarade med status: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode != 200 {
                    self.errorMessage = "Server svarade med felkod: \(httpResponse.statusCode)"
                    return
                }
            }
            
            let decoder = JSONDecoder()
            let authResponse = try decoder.decode(AuthResponse.self, from: data)
            
            self.userName = authResponse.email
            print("Användare inloggad: \(authResponse.name), Email: \(authResponse.email)")
            
            // Spara användardata i SwiftData
            userStorage.saveUser(userId: self.userId, email: authResponse.email)
            
        } catch {
            self.errorMessage = "Fel: \(error.localizedDescription)"
        }
    }
}
