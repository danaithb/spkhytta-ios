//
//  Untitled.swift
//  Spkhytta-iOS
//
//  Created by Jana Carlsson on 21/04/2025.
//

//
//  User.swift
//  hytte
//
//  Created by Mariana and Abigail on 01/04/2025.
//TODO i backend?
//lägg till modifiedAt om man ska kunna ändra. detta borde vara med i framtiden. samma sak med att ha med createdAt

import Foundation
import SwiftData

@Model
class User {
    @Attribute(.unique) var id: UUID          // SwiftData-kompatibel unik ID
    var firebaseId: String                    // Firebase UID sparas separat
    var email: String
    var name: String
    var isAdmin: Bool

    init(firebaseId: String, email: String, name: String, isAdmin: Bool = false) {
        self.id = UUID()                      // Genereras automatiskt
        self.firebaseId = firebaseId
        self.email = email
        self.name = name
        self.isAdmin = isAdmin
    }
}

