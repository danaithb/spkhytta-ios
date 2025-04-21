//
//  Untitled.swift
//  Spkhytta-iOS
//
//  Created by Jana Carlsson on 21/04/2025.
//
//import Foundation
//import SwiftData
//
//@Model
//class User {
//    var userId: String
//    var email: String
//    var displayName: String
//    var createdAt: Date
//    
//    init(userId: String, email: String) {
//        self.userId = userId
//        self.email = email
//        self.displayName = Self.formatDisplayName(from: email)
//        self.createdAt = Date()
//    }
//    
//    static func formatDisplayName(from email: String) -> String {
//        if let username = email.split(separator: "@").first {
//            return String(username)
//                .replacingOccurrences(of: ".", with: " ")
//        }
//        return "Användare"
//    }
//}
//
//  User.swift
//  hytte
//
//  Created by Mariana and Abigail on 01/04/2025.
//

//
//  User.swift
//  hytte
//
//  Created by Mariana and Abigail on 01/04/2025.
//

//
//  User.swift
//  hytte
//
//  Created by Mariana and Abigail on 01/04/2025.
//lägg till modifiedAt om man ska kunna ändra. detta borde vara med i framtiden. samma sak med att ha med createdAt

import Foundation
import SwiftData

@Model
class User {
    @Attribute(.unique) var userId: String
    var email: String
    var displayName: String
    var phoneNumber: String
    //var createdAt: Date görs av backend, skickas aldrig från frontend.
    
    init(userId: String, email: String, displayName: String, phoneNumber: String = "+46 70 123 45 67") {
        self.userId = userId
        self.email = email
        self.displayName = displayName
        self.phoneNumber = phoneNumber
        //self.createdAt = Date()
    }
}
