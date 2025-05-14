//
// PublicHolidaysAPIClient.swift

// Created by Mariana och Abigail on 05/02/2025.



import Foundation

// ---------- API-klient för helgdagar ----------
class PublicHolidaysAPIClient {
    static let shared = PublicHolidaysAPIClient()
    private init() {}
    
    //Henter
    func fetchPublicHolidays(
        year: Int = Calendar.current.component(.year, from: Date()),
        countryCode: String = "NO"
    ) async throws -> [PublicHolidayModel] {
        //URL:en
        guard let url = PublicHolidaysAPIEndpoints.publicHolidaysUrl(year: year, countryCode: countryCode) else {
            throw URLError(.badURL)
        }
        
       
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Validere
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // BUG: Datohenting kan vara feil om TimeZone saknas
        // FIX: Lagt till UTC tidszon för att säkerställa korrekt datumhantering, hjelp fra Swift json time value local time zone og Danial på SPK.
        
        let decoder = JSONDecoder()
        let holidays = try decoder.decode([Holiday].self, from: data)
        
        //konverter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let publicHolidayModels = holidays.map { holiday in
            PublicHolidayModel(
                date: dateFormatter.date(from: holiday.date) ?? Date(),
                localName: holiday.localName,
                name: holiday.name,
                countryCode: holiday.countryCode,
                fixed: holiday.fixed,
                global: holiday.global,
                counties: holiday.counties ?? [],
                launchYear: holiday.launchYear,
                types: holiday.types
            )
        }
        
        return publicHolidayModels
    }
}
