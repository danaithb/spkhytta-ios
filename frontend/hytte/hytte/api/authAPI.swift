
//  authAPI.swift
//  hytte
//
//  Created by Mariana och Abigail on 22/02/2025.
//skicka user id till backend
//
//det här api:et är inte nog säkert att använda. så vi bör köra ett traditionellet från backens.

import Foundation

func authAPI(authViewModel: AuthViewModel) {
    guard let userId = authViewModel.getFirebaseUserId() else {//från viewmodel
        print("No user logged in")
        return
    }
    
    print("User logged in as: \(userId)")
    let url = URL (string: "https://api.example.com/api/auth/login")!//byt epi.example.com till, api/auth/login följer backend koden domännamn
    var request = URLRequest(url: url)
    request.httpMethod = "POST"//ingen kan se
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
//applikationen på servern så kan vi testa denna.
//om inte den ska va på serbern så måste jag iaf ha domännamn
//bara

