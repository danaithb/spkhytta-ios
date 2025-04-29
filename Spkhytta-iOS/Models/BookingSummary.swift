//
//  BookingSummary.swift
//  Spkhytta-iOS
//
//  Created by Danait Hadra on 29/04/2025.
//

import Foundation

struct BookingSummary: Codable, Identifiable {
    let bookingCode: String?
    let cabinName: String
    let startDate: String
    let endDate: String
    let status: String
    let price: Double

    var id: String {
        bookingCode ?? UUID().uuidString // fallback hvis null
    }
}
