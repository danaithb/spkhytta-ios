//
//  PublicHolidaysAPIEndpoint.swift
//  booking
//
//  Created by Mariana och Abigail on 03/02/2025.
//

//ska bara få in holidays en gång så ska de sparas i en databas. sen ska holidays hämtas från databsen. (kolla if they are avalible from the database or not. if not. get them.)
//backend kan hämta röda dagar översikten.


// TODO
// 1. Spara helgdagar i lokal databas efter första hämtningen
// 2. Implementera kontroll om helgdagar finns i databasen innan API-anrop
// 3. Flytta helgdagshämtning till backend

import Foundation
// ---------- API-endpoints för helgdagar ----------
struct PublicHolidaysAPIEndpoints {
    private static let scheme = "https"
    private static let host = "date.nager.at"
    private static let path = "/api/v3/PublicHolidays"
    
    // Konstruerar URL för att hämta helgdagar
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
