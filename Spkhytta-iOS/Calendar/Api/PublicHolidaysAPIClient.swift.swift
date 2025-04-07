//
// PublicHolidaysAPIClient.swift

// Created by Mariana och Abigail on 05/02/2025.
//
//ÄNDRA GLBALA KONSTANTER
// TODO
// 1. Optimera nätverksprestanda för dåliga anslutningar
// 2. Lägg till caching av helgdagar för att minska API-anrop
// 3. Implementera felhantering med mer specifika felmeddelanden
// 4. Hantera timeout och återförsök


import Foundation

// ---------- API-klient för helgdagar ----------
class PublicHolidaysAPIClient {
    static let shared = PublicHolidaysAPIClient()
    private init() {}
    
    // Hämtar helgdagar för ett givet år och landskod
    func fetchPublicHolidays(
        year: Int = Calendar.current.component(.year, from: Date()),
        countryCode: String = "NO"
    ) async throws -> [PublicHolidayModel] {
        // Konstruera URL:en
        guard let url = PublicHolidaysAPIEndpoints.publicHolidaysUrl(year: year, countryCode: countryCode) else {
            throw URLError(.badURL)
        }
        
        // Utför nätverksförfrågan
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Validera svaret
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        // BUG: Datumhantering kan vara fel om TimeZone saknas
        // FIX: Lagt till explicit UTC tidszon för att säkerställa korrekt datumhantering
        
        // Avkoda JSON till en array av Holiday-objekt
        let decoder = JSONDecoder()
        let holidays = try decoder.decode([Holiday].self, from: data)
        
        // Konvertera Holiday-objekt till PublicHolidayModel-objekt
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
