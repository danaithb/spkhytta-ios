//
//  PublicHolidaysAPIEndpoint.swift
//  booking
//
//  Created by Mariana och Abigail on 03/02/2025.


import Foundation
// ---------- API-endpoints för hellidager ----------
struct PublicHolidaysAPIEndpoints {
    private static let scheme = "https"
    private static let host = "date.nager.at"
    private static let path = "/api/v3/PublicHolidays"
    
    //hente helligdagar
    static func publicHolidaysUrl(
        year: Int = Calendar.current.component(.year, from: Date()),
        countryCode: String = "NO"
    ) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = "\(path)/\(year)/\(countryCode)"
        
        return components.url
    }
}
