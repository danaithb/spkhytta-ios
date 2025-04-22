//  UserStorage.swift
//  hytte
//
// Created by Mariana and Abigail on 01/04/2025.
//
//  Den här klassen hanterar sparad användardata lokalt på enheten

import Foundation
import SwiftData

@MainActor
class UserStorage: ObservableObject {
    let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func saveUser(_ user: User) {
        // Check if user with this firebaseId already exists
        if let existingUser = fetchUser(byFirebaseId: user.firebaseId) {
            print("🗄️ User with firebaseId \(user.firebaseId) already exists, updating")
            // Update existing user properties
            existingUser.email = user.email
            existingUser.name = user.name
            existingUser.isAdmin = user.isAdmin
        } else {
            print("🗄️ Adding new user with firebaseId \(user.firebaseId)")
            modelContext.insert(user)
        }
        
        do {
            try modelContext.save()
            print("🗄️ User saved successfully")
        } catch {
            print("🗄️ Failed to save user: \(error)")
        }
    }

    func fetchUser(byFirebaseId firebaseId: String) -> User? {
        print("🗄️ Fetching user with firebaseId: \(firebaseId)")
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.firebaseId == firebaseId })
        do {
            let result = try modelContext.fetch(descriptor)
            print("🗄️ Found \(result.count) users matching firebaseId")
            return result.first
        } catch {
            print("🗄️ Error fetching user: \(error)")
            return nil
        }
    }

    func deleteUser(_ user: User) {
        modelContext.delete(user)
        try? modelContext.save()
    }
}
