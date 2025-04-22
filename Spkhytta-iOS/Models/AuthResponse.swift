//
//  AuthResponse.swift
//  Spkhytta-iOS
//
//  Created by Mariana och Abigail on 21/04/2025.
//

//
//  AuthResponse.swift
//  Spkhytta-iOS
//

//
//  AuthResponse.swift
//  Spkhytta-iOS
//

import Foundation

struct AuthResponse: Codable {
    let userId: Int
    let firebaseUid: String
    let name: String
    let email: String
    let isAdmin: Bool?
    
    enum CodingKeys: String, CodingKey {
        case userId
        case firebaseUid
        case name
        case email
        case isAdmin
    }
}
