//CalendarViewModel.swift

//Created by Mariana och Abigail on 12/03/2025


import Foundation
import SwiftUI
import FirebaseAuth

class CalendarViewModel: ObservableObject {
    // Publicerade egenskaper
    @Published var currentMonth: Date = Date()
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var holidays: [PublicHolidayModel] = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var backendUnavailableDates: Set<Date> = []
    
    // Kalenderinställningar
    let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Starta veckan på måndag
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    // Ladda otillgängliga datum från backend
    func loadBackendUnavailableDates(forMonth month: String, cabinId: Int) {
        guard let user = Auth.auth().currentUser else { return }

        user.getIDToken { token, error in
            guard let token = token else { return }

            guard let url = URL(string: "https://hytteportalen-307333592311.europe-west1.run.app/api/calendar/availability") else {
                print("Ogiltig URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let body: [String: Any] = [
                "month": month,
                "cabinId": cabinId
            ]

            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

            URLSession.shared.dataTask(with: request) { data, _, _ in
                guard let data = data else { return }
                do {
                    let result = try JSONDecoder().decode([DayAvailability].self, from: data)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    formatter.timeZone = TimeZone(secondsFromGMT: 0)
                    let dates = result
                        .filter { $0.status == "booked" }
                        .compactMap { formatter.date(from: $0.date) }

                    DispatchQueue.main.async {
                        self.backendUnavailableDates = Set(dates.map(self.normalizeDate))
                    }
                } catch {
                    print("Fel vid tolkning: \(error)")
                }
            }.resume()
        }
    }
    
    // Normalisera datum för jämförelse
    func normalizeDate(_ date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)!
    }
    
    // Ladda röda dagar
    func loadHolidays() async {
        do {
            let fetchedHolidays = try await PublicHolidaysAPIClient.shared.fetchPublicHolidays()
            await MainActor.run {
                holidays = fetchedHolidays
                print("Laddade \(holidays.count) helgdagar")
            }
        } catch {
            await MainActor.run {
                alertMessage = "Misslyckades att ladda helgdagar: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
    
    // Gå till nästa eller föregående månad
    func moveMonth(by value: Int) {
        if canMoveMonth(by: value) {
            currentMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) ?? currentMonth
            print("Flyttade till \(formatMonth(date: currentMonth))")
            
            let monthString = Calendar.monthOnlyFormatter.string(from: currentMonth)
            loadBackendUnavailableDates(forMonth: monthString, cabinId: 1)
        }
    }
    
    // Kontrollera om det är tillåtet att navigera till ny månad
    private func canMoveMonth(by value: Int) -> Bool {
        guard let newDate = calendar.date(byAdding: .month, value: value, to: currentMonth),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: newDate))
        else {
            return false
        }
        
        return value < 0
            ? startOfMonth >= CalendarConstants.minDate
            : startOfMonth <= CalendarConstants.maxDate
    }
    
    // Formatera datum till månad och år
    func formatMonth(date: Date) -> String {
        return Calendar.monthYearFormatter.string(from: date)
    }
    
    // Kontrollera om datumvalet är giltigt
    func validateDateSelection() -> Bool {
        if startDate == nil {
            alertMessage = "Vänligen välj ett datum."
            showAlert = true
            return false
        }
        
        if endDate == nil {
            alertMessage = "Vänligen välj både start- och slutdatum."
            showAlert = true
            return false
        }
        
        return true
    }
    
    // Hantera val av datum
    func handleDateSelection(date: Date) {
        let normalizedDate = normalizeDate(date)
        
        if startDate == nil {
            startDate = normalizedDate
            print("Valde startdatum: \(normalizedDate)")
        } else if endDate == nil {
            let normalizedStart = normalizeDate(startDate!)
            
            if normalizedDate > normalizedStart {
                if isRangeValid(start: normalizedStart, end: normalizedDate) {
                    endDate = normalizedDate
                    print("Valde slutdatum: \(normalizedDate)")
                } else {
                    alertMessage = "Några av de valda datumen är inte tillgängliga."
                    showAlert = true
                    startDate = nil
                }
            } else if normalizedDate < normalizedStart {
                startDate = normalizedDate
                endDate = nil
                print("Bytte till ett tidigare startdatum: \(normalizedDate)")
            }
        } else {
            startDate = normalizedDate
            endDate = nil
            print("Återställde och valde nytt startdatum: \(normalizedDate)")
        }
    }
    
    // Validera att alla datum i spannet är tillgängliga
    private func isRangeValid(start: Date, end: Date) -> Bool {
        var currentDate = start
        while currentDate <= end {
            if backendUnavailableDates.contains(normalizeDate(currentDate)) {
                return false
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return true
    }
    
    // Hämta alla dagar som ska visas i kalendern
    func getCalendarDays() -> [DateWrapper] {
        var days = [DateWrapper]()
        
        // Hämta månadens startdatum
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let startOfMonth = calendar.date(from: components) else {
            return days
        }
        
        // Hämta antal dagar i månaden
        guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return days
        }
        
        // Beräkna vilken veckodag månaden startar på
        let firstDayOfMonth = calendar.component(.weekday, from: startOfMonth)
        let firstWeekdayIndex = (firstDayOfMonth - calendar.firstWeekday + 7) % 7
        
        // Lägg till tomma celler i början
        for _ in 0..<firstWeekdayIndex {
            days.append(DateWrapper(date: nil))
        }
        
        // Lägg till faktiska dagar i månaden
        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(DateWrapper(date: date))
            }
        }
        
        // Lägg till tomma celler för att fylla upp rutnäet
        let totalCells = 6 * 7
        let newCells = totalCells - days.count
        for _ in 0..<max(0, newCells) {
            days.append(DateWrapper(date: nil))
        }
        
        return days
    }
    
    // Lägg till denna funtion om den saknas
    func isDateInRange(date: Date) -> Bool {
        let normalizedDate = normalizeDate(date)
        
        if let start = startDate, endDate == nil {
            return normalizeDate(start) == normalizedDate
        } else if let start = startDate, let end = endDate {
            return normalizedDate >= normalizeDate(start) && normalizedDate <= normalizeDate(end)
        }
        return false
    }
    
    // Kontrollera om ett datum är en helgdag
    func isHoliday(date: Date) -> Bool {
        let normalizedDate = normalizeDate(date)
        return holidays.contains { holiday in
            // Om holiday.date inte är optional behöver vi inte avpaketa den
            return normalizeDate(holiday.date) == normalizedDate
        }
    }
}

// Formatter för månad utan dag
extension Calendar {
    static let monthOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }()
}
