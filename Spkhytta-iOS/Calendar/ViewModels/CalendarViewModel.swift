//CalendarViewModel.swift

//Created by Mariana och Abigail on 12/03/2025

//Todo se över s¨att det visas erroe om man inte har tryckt på en knapp. Fungerade föru, men inte nu.

import Foundation
import SwiftUI
import FirebaseAuth

class CalendarViewModel: ObservableObject {
    //Publicerade egenskaper
    @Published var currentMonth: Date = Date()
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var holidays: [PublicHolidayModel] = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var backendUnavailableDates: Set<Date> = []
    
    //Egenskaper
    let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Start the week on Monday
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    
    // Metoder
    
    func loadBackendUnavailableDates(forMonth month: String, cabinId: Int) {
        guard let user = Auth.auth().currentUser else { return }

        user.getIDToken { token, error in
            guard let token = token else { return }

            guard let url = URL(string: "https://test2-hyttebooker-371650344064.europe-west1.run.app/api/calendar/availability") else {
                print("Ugyldig URL")
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
                    print("Feil ved parsing: \(error)")
                }
            }.resume()
        }
    }
    
    // Normalize date för jämföroing
    func normalizeDate(_ date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)!
    }
    
    func loadHolidays() async {
        do {
            let fetchedHolidays = try await PublicHolidaysAPIClient.shared.fetchPublicHolidays()
            await MainActor.run {
                holidays = fetchedHolidays
                print("Loaded \(holidays.count) holidays")
            }
        } catch {
            await MainActor.run {
                alertMessage = "Failed to load holidays: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
    
    // Gå til neste eller forrige måned
    func moveMonth(by value: Int) {
        if canMoveMonth(by: value) {
            currentMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) ?? currentMonth
            print("Moved to \(formatMonth(date: currentMonth))")
            
            let monthString = Calendar.monthOnlyFormatter.string(from: currentMonth)
            loadBackendUnavailableDates(forMonth: monthString, cabinId: 1)
        }
    }
    
    // Kontrollera om månadsnavigering är tillåten
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
    
    // Formatera månad och år
    func formatMonth(date: Date) -> String {
        return Calendar.monthYearFormatter.string(from: date)
    }
    
    // Kontrollera om datum är valda
    func validateDateSelection() -> Bool {
        if startDate == nil {
            alertMessage = "Vennligst velg en dato."
            showAlert = true
            return false
        }
        
        if endDate == nil {
            alertMessage = "Vennligst velg både start- og sluttdato."
            showAlert = true
            return false
        }
        
        return true
    }
    
    // Hantera date selection
    func handleDateSelection(date: Date) {
        let normalizedDate = normalizeDate(date)
        
        if startDate == nil {
            startDate = normalizedDate
            print("Selected start: \(normalizedDate)")
        } else if endDate == nil {
            let normalizedStart = normalizeDate(startDate!)
            
            if normalizedDate > normalizedStart {
                if isRangeValid(start: normalizedStart, end: normalizedDate) {
                    endDate = normalizedDate
                    print("Selected end: \(normalizedDate)")
                } else {
                    alertMessage = "Noen av de valgte datoene er utilgjengelige."
                    showAlert = true
                    startDate = nil
                }
            } else if normalizedDate < normalizedStart {
                startDate = normalizedDate
                endDate = nil
                print("Switched to earlier start: \(normalizedDate)")
            }
        } else {
            startDate = normalizedDate
            endDate = nil
            print("Reset and selected new start: \(normalizedDate)")
        }
    }
    
    // Validera datumintervall
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
    
    func getCalendarDays() -> [DateWrapper] {
        var days = [DateWrapper]()
        
        // Get the start of the month
        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let startOfMonth = calendar.date(from: components) else {
            return days
        }
        
        // Get the range of days in the month
        guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else {
            return days
        }
        
        // Calculate the first weekday of the month
        let firstDayOfMonth = calendar.component(.weekday, from: startOfMonth)
        let firstWeekdayIndex = (firstDayOfMonth - calendar.firstWeekday + 7) % 7
        
        // Add empty days for the first week
        for _ in 0..<firstWeekdayIndex {
            days.append(DateWrapper(date: nil))
        }
        
        // Add days of the month
        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(DateWrapper(date: date))
            }
        }
        
        // Add empty days to fill the grid
        let totalCells = 6 * 7
        let newCells = totalCells - days.count
        for _ in 0..<max(0, newCells) {
            days.append(DateWrapper(date: nil))
        }
        
        return days
    }
    
    // Lägg till denna funktion om den saknas
    func isDateInRange(date: Date) -> Bool {
        let normalizedDate = normalizeDate(date)
        
        if let start = startDate, endDate == nil {
            return normalizeDate(start) == normalizedDate
        } else if let start = startDate, let end = endDate {
            return normalizedDate >= normalizeDate(start) && normalizedDate <= normalizeDate(end)
        }
        return false
    }
    
    func isHoliday(date: Date) -> Bool {
        let normalizedDate = normalizeDate(date)
        return holidays.contains { holiday in
            // If holiday.date is not optional, we don't need to unwrap it
            return normalizeDate(holiday.date) == normalizedDate
        }
    }
}

extension Calendar {
    static let monthOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        return formatter
    }()
}
