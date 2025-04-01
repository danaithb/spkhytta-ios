//
//  Holiday.swift
//  Calendar
//
//  Created by Jana Carlsson on 23/03/2025.
//

import Foundation

struct Holiday: Decodable {
    let date: String
    let localName: String
    let name: String
    let countryCode: String
    let fixed: Bool
    let global: Bool
    let counties: [String]?
    let launchYear: Int?
    let types: [String]
}
