//
//  AuthResponse.swift
//  Spkhytta-iOS
//
//  Created by Jana Carlsson on 21/04/2025.
//

import Foundation

struct AuthResponse: Codable {
    let name: String
    let email: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case name, email, token
    }
}
