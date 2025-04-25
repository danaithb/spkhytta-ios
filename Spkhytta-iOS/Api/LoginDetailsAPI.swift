//
//  LoginDetailsAPI.swift
//  Spkhytta-iOS
//
//  Created by Mariana och Abigail on 14/04/2025.


//endpoint: "/login"...
//AuthResponseDTO response = new AuthResponseDTO(
//                    user.getUserId().intValue(),
//                    user.getFirebaseUid(),
//                    user.getName(),
//                    user.getEmail()
//            );

//vi behöver ha: namn, epost, mobil nummer, email, skickar bokningar gjorda.


import Foundation
import FirebaseAuth

struct UserInfoDTO: Codable {
    let name: String
    let email: String
    let points: Int
}

func loginToBackend() {
    guard let user = Auth.auth().currentUser else {
        print("Ingen bruker er logget inn")
        return
    }
    
    user.getIDToken { token, error in
        if let error = error {
            print("Feil ved henting av token: \(error.localizedDescription)")
            return
        }
        
        guard let token = token else {
            print("Token er nil")
            return
        }
        
        let url = URL(string: "https://test2-hyttebooker-371650344064.europe-west1.run.app/api/auth/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // Body skal være tom, backend henter alt fra token
        request.httpBody = "{}".data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("Status: \(httpResponse.statusCode)")
            }

            if let data = data, let body = String(data: data, encoding: .utf8) {
                print("Response body: \(body)")
            }
        }.resume()
    }
}
