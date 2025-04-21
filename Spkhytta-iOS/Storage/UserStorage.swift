////
////  UserStorage.swift
////  Spkhytta-iOS
////
////  Created by Jana Carlsson on 21/04/2025.
////
////
////  UserStorage.swift
////  hytte
////
////  Created by Mariana and Abigail on 01/04/2025.
////
////  Den här klassen hanterar sparad användardata lokalt på enheten
////
//
//import SwiftUI
//import SwiftData
//
//class UserStorage: ObservableObject {
//    let container: ModelContainer  // SwiftData container för användardata
//    
//    init() {
//        do {
//            // Skapar en SwiftData-container som bara lagrar User-objekt
//            container = try ModelContainer(for: User.self)
//        } catch {
//            fatalError("Kunde inte skapa UserStorage: \(error)")
//        }
//    }
//    
//    var modelContext: ModelContext {
//        return container.mainContext
//    }
//}
//
//  UserStorage.swift
//  hytte
//
//  Created by Mariana and Abigail on 01/04/2025.
//
//  Hanterar lagring av användardata med SwiftData
//

//
//  UserStorage.swift
//  hytte
//
//  Created by Mariana and Abigail on 01/04/2025.
//
//  Hanterar lagring av användardata med SwiftData
//

//
//  UserStorage.swift
//  hytte
//
//  Created by Mariana and Abigail on 01/04/2025.
//
//  Hanterar lagring av användardata med SwiftData
//

import SwiftUI
import SwiftData

@MainActor
class UserStorage: ObservableObject {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: User.self)
        } catch {
            fatalError("Kunde inte skapa UserStorage: \(error)")
        }
    }
    
    // Spara användardata
    func saveUser(userId: String, email: String) {
        let context = container.mainContext
        
        // Kolla först om användaren redan finns
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { user in
            user.userId == userId
        })
        
        do {
            let existingUsers = try context.fetch(descriptor)
            
            if let existingUser = existingUsers.first {
                // Uppdatera befintlig användare
                existingUser.email = email
                existingUser.displayName = formatDisplayName(from: email)
            } else {
                // Skapa ny användare
                let newUser = User(
                    userId: userId,
                    email: email,
                    displayName: formatDisplayName(from: email),
                    phoneNumber: "+46 70 123 45 67"  // Dummy telefonnummer
                )
                context.insert(newUser)
            }
            
            try context.save()
        } catch {
            print("Fel vid sparande av användare: \(error)")
        }
    }
    
    // Hämta användare med ID
    func getUser(by userId: String) -> User? {
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { user in
            user.userId == userId
        })
        
        do {
            let users = try container.mainContext.fetch(descriptor)
            return users.first
        } catch {
            print("Fel vid hämtning av användare: \(error)")
            return nil
        }
    }
    
    // Formatera displayName från e-post
    private func formatDisplayName(from email: String) -> String {
        if let username = email.split(separator: "@").first {
            return String(username)
                .replacingOccurrences(of: ".", with: " ")
                .split(separator: " ")
                .map { $0.prefix(1).uppercased() + $0.dropFirst() }
                .joined(separator: " ")
        }
        return "Användare"
    }
    
    // Ta bort användare (vid utloggning)
    func deleteUser(userId: String) {
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { user in
            user.userId == userId
        })
        
        do {
            let users = try container.mainContext.fetch(descriptor)
            for user in users {
                container.mainContext.delete(user)
            }
            try container.mainContext.save()
        } catch {
            print("Fel vid borttagning av användare: \(error)")
        }
    }
}
