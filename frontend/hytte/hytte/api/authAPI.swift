//
//  authAPI.swift
//  hytte
//
//  Created by Jana Carlsson on 22/02/2025.
//

import Foundation

func authAPI(authViewModel: AuthViewModel) {
    guard let userId = authViewModel.getFirebaseUserId() else {//från viewmodel
        print("No user logged in")
        return
    }
    
    print("User logged in as: \(userId)")
    let url = URL (string: "https://api.example.com/api/auth/login")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    let body: [String: String] = ["userId": userId]
    request.httpBody = try? JSONSerialization.data(withJSONObject: body)
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            print("No HTTP response")
            return
        }
        if httpResponse.statusCode != 200 {
            print("Status code: \(httpResponse.statusCode)")
            return
        }
        guard let data = data else {
            print("No data")
            return
        }
        do {
            if let responseJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print(responseJson)
            } else {
                print("failed to parse JSON")
            }
        } catch {
            print("error in JSON respond: \(error)")
        }
    }
    
}
//connect kalla från view för testing. 

