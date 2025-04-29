//
//  UserAPIClient.swift
//  Spkhytta-iOS
//
//  Created by Danait Hadra on 29/04/2025.
//

import Foundation
import FirebaseAuth

class UserAPIClient {
    static let shared = UserAPIClient()

    private init() {}

    func fetchUserInfo(completion: @escaping (UserInfo?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("[UserAPIClient] Ingen bruker er logget inn.")
            completion(nil)
            return
        }

        currentUser.getIDToken { token, error in
            guard let token = token else {
                print("[UserAPIClient] Kunne ikke hente ID-token:", error?.localizedDescription ?? "Ukjent feil")
                completion(nil)
                return
            }

            guard let url = URL(string: "https://test2-hyttebooker-371650344064.europe-west1.run.app/api/users/me") else {
                print("[UserAPIClient] Ugyldig URL.")
                completion(nil)
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            print("[UserAPIClient] Sender forespørsel til /api/users/me ...")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("[UserAPIClient] Feil ved nettverkskall:", error.localizedDescription)
                    completion(nil)
                    return
                }

                guard let data = data else {
                    print("[UserAPIClient] Mottok ingen data fra server.")
                    completion(nil)
                    return
                }

                do {
                    let userInfo = try JSONDecoder().decode(UserInfo.self, from: data)
                    print("[UserAPIClient] Brukerinfo hentet:")
                    print("- Navn:", userInfo.name)
                    print("- E-post:", userInfo.email)
                    print("- Poeng:", userInfo.points)
                    completion(userInfo)
                } catch {
                    print("[UserAPIClient] Klarte ikke å parse respons:", error.localizedDescription)
                    completion(nil)
                }
            }.resume()
        }
    }
}
