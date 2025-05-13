//
//  DateWrapper.swift
//  Calendar
//
//  Created by Mariana och Abigail on 17/03/2025.
//

import Foundation


// vår wrapper struct för att ge varje cell en unik id
//hashing ger mer unikt reultat än mapping. kan använda date string etc som key.
struct DateWrapper: Identifiable, Hashable {
    let id = UUID()
    let date: Date?
    //kollar om datum är lika på båda sidor eller inte. jämför id istället för timestamp etc.
    static func == (lhs: DateWrapper, rhs: DateWrapper) -> Bool {
        return lhs.id == rhs.id
        //om två darum valda eller inte. unavalible dates tex vill se om ett är tillgängligt eller inte. jämför om ett är ojämnt eller inte. ser ett på höger och vänster och jämör dess id.
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    } //kan göra med olika tekniker, här är biilt in, använder id som hash-key, tar id och hashar det.
}
