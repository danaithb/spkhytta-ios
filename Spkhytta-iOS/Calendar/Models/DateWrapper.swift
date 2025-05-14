//
//  DateWrapper.swift
//  Calendar
//
//  Created by Mariana och Abigail on 17/03/2025.
//

import Foundation

struct DateWrapper: Identifiable, Hashable {
    let id = UUID()
    let date: Date?
    //hvis datoer er like, eller ikke, hjelp fra Mohammad Data Ingenjør
    static func == (lhs: DateWrapper, rhs: DateWrapper) -> Bool {
        return lhs.id == rhs.id
     }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
