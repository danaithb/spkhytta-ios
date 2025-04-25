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
    @Published var userInfo: UserInfoDTO? = nil

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
    //lägg till en guard här

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
                        loginToBackend()
                        self.fetchUserInfo() // setter info direkte i viewmodel
                    }
                })

                print(self.userId)
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
                print("Kunde ikke hente token: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(token)
        }
    }

    func sendTokenToBackend() {
        Auth.auth().currentUser?.getIDToken { token, error in
            guard let token = token else {
                print("Kunde ikke få token: \(error?.localizedDescription ?? "Ukjent feil")")
                return
            }

            var request = URLRequest(url: URL(string: "https://test2-hyttebooker-371650344064.europe-west1.run.app/api/auth/login")!)
            request.httpMethod = "POST" //ändrat till post från GET.
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Nettverksfeil: \(error.localizedDescription)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Server svarte med status: \(httpResponse.statusCode)")
                }
            }.resume()
        }
    }
    
    func fetchUserInfo() {
        getToken { token in
            guard let token = token else {
                print("Token mangler")
                return
            }

            var request = URLRequest(url: URL(string: "https://test2-hyttebooker-371650344064.europe-west1.run.app/api/users/me")!)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Feil ved henting av brukerinfo: \(error.localizedDescription)")
                    return
                }

                if let data = data {
                    do {
                        let userInfo = try JSONDecoder().decode(UserInfoDTO.self, from: data)
                        DispatchQueue.main.async {
                            self.userInfo = userInfo
                            print("Navn: \(userInfo.name), E-post: \(userInfo.email), Poeng: \(userInfo.points)")
                        }
                    } catch {
                        print("Feil ved parsing av brukerinfo: \(error.localizedDescription)")
                    }
                }
            }.resume()
        }
    }

}



