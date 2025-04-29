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
            print("Ikke innlogget")
            completion(nil)
            return
        }

        currentUser.getIDToken { token, error in
            guard let token = token else {
                print("Kunne ikke hente token: \(error?.localizedDescription ?? "Ukjent feil")")
                completion(nil)
                return
            }

            guard let url = URL(string: "https://test2-hyttebooker-371650344064.europe-west1.run.app/api/users/me") else {
                completion(nil)
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let userInfo = try JSONDecoder().decode(UserInfo.self, from: data)
                        completion(userInfo)
                    } catch {
                        print("Feil ved parsing: \(error)")
                        completion(nil)
                    }
                } else {
                    print("Ingen data: \(error?.localizedDescription ?? "Ukjent feil")")
                    completion(nil)
                }
            }.resume()
        }
    }
}
