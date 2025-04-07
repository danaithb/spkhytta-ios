//PublicHolidayModel.swift
//
//  Created by Mariana och Abigail on 27/12/2025.
//
//

import Foundation

struct PublicHolidayModel: Identifiable, Codable, Hashable {
    var id: UUID // Unique identifier
    let date: Date
    let localName: String
    let name: String
    let countryCode: String
    let fixed: Bool // om samma datu varje rå.
    let global: Bool
    let counties: [String]
    let launchYear: Int?
    let types: [String]
    
    init(id: UUID = UUID(),
         date: Date,
         localName: String,
         name: String,
         countryCode: String,
         fixed: Bool,
         global: Bool,
         counties: [String],
         launchYear: Int?,
         types: [String]) {
        self.id = id
        self.date = date
        self.localName = localName
        self.name = name
        self.countryCode = countryCode
        self.fixed = fixed
        self.global = global
        self.counties = counties
        self.launchYear = launchYear
        self.types = types
    }
}
