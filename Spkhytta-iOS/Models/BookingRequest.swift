//
//  BookingRequest.swift
//  Spkhytta-iOS
//
//  Created by Danait Hadra on 29/04/2025.
//

import Foundation

struct BookingRequest: Codable {
    let cabinId: Int
    let startDate: String
    let endDate: String
    let guestCount: Int
}
