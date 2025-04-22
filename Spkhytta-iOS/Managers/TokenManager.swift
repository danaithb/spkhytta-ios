//
//  TokenManager.swift
//  Spkhytta-iOS
//
//  Created by Jana Carlsson on 21/04/2025.
//

import Foundation

class TokenManager: ObservableObject {
    static let shared = TokenManager()

    @Published var idToken: String? = nil

    private init() {}

    func updateToken(_ token: String) {
        self.idToken = token
    }

    func clearToken() {
        self.idToken = nil
    }
}

