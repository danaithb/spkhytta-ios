//CalendarViewModel.swift

//Created by Mariana och Abigail on 12/03/2025

//Todo se över s¨att det visas erroe om man inte har tryckt på en knapp. Fungerade föru, men inte nu.



import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import Foundation


class CalendarViewModel: ObservableObject {
    @Published var currentMonth: Date = Date()
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var holidays: [PublicHolidayModel] = []
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var unavailableDatesFromServer: [DateRange] = []

    let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }()

    var unavailableDates: Set<Date> {
        var dates = Set<Date>()
        for range in unavailableDatesFromServer {
            if let start = range.startDate, let end = range.endDate {
                var current = start
                while current <= end {
                    dates.insert(normalizeDate(current))
                    current = calendar.date(byAdding: .day, value: 1, to: current)!
                }
            }
        }

        if unavailableDatesFromServer.isEmpty {
            dates = Set([
                calendar.date(from: DateComponents(year: 2025, month: 3, day: 14))!,
                calendar.date(from: DateComponents(year: 2025, month: 3, day: 20))!,
                calendar.date(from: DateComponents(year: 2025, month: 4, day: 16))!
            ].map { normalizeDate($0) })
        }

        return dates
    }

    func normalizeDate(_ date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)!
    }

    func getCalendarDays() -> [DateWrapper] {
        var days = [DateWrapper]()

        let components = calendar.dateComponents([.year, .month], from: currentMonth)
        guard let startOfMonth = calendar.date(from: components) else { return days }

        guard let range = calendar.range(of: .day, in: .month, for: startOfMonth) else { return days }

        let firstDayOfMonth = calendar.component(.weekday, from: startOfMonth)
        let firstWeekdayIndex = (firstDayOfMonth - calendar.firstWeekday + 7) % 7

        for _ in 0..<firstWeekdayIndex {
            days.append(DateWrapper(date: nil))
        }

        for day in 1...range.count {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                days.append(DateWrapper(date: date))
            }
        }

        let totalCells = 6 * 7
        let newCells = totalCells - days.count
        for _ in 0..<max(0, newCells) {
            days.append(DateWrapper(date: nil))
        }

        return days
    }

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
            return normalizeDate(holiday.date) == normalizedDate
        }
    }

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

    private func isRangeValid(start: Date, end: Date) -> Bool {
        var currentDate = start
        while currentDate <= end {
            if unavailableDates.contains(normalizeDate(currentDate)) {
                return false
            }
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return true
    }

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

    func moveMonth(by value: Int) {
        if canMoveMonth(by: value) {
            currentMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) ?? currentMonth
            print("Moved to \(formatMonth(date: currentMonth))")
        }
    }

    private func canMoveMonth(by value: Int) -> Bool {
        guard let newDate = calendar.date(byAdding: .month, value: value, to: currentMonth),
              let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: newDate)) else {
            return false
        }

        return value < 0
            ? startOfMonth >= CalendarConstants.minDate
            : startOfMonth <= CalendarConstants.maxDate
    }

    func formatMonth(date: Date) -> String {
        return Calendar.monthYearFormatter.string(from: date)
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

    private func checkDateAvailability(startDate: Date, endDate: Date, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Ingen inloggad användare"])))
            return
        }

        currentUser.getIDToken { token, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let token = token else {
                completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Ingen token hittades"])))
                return
            }

            completion(.success(true)) // Simulerat svar
        }
    }
}

