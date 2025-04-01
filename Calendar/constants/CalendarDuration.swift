//
//  Calendar.swift
//  booking
//
//  Created by Jana Carlsson on 18/02/2025.
//

//import Foundation
//

//struct CalendarConstants {
//    static let weekdaySymbols = ["Mån", "Tis", "Ons", "Tors", "Fre", "Lör", "Sön"]
//    static let minDate = Calendar.current.date(from: DateComponents(year: 2024, month: 1, day: 1))!
//    static let maxDate = Calendar.current.date(from: DateComponents(year: 2030, month: 5, day: 1))!
//}
import Foundation
import SwiftUI

//här kan det vara att jag måste anpassa för UTC, är det bäst att göra det här eller i kalender koden?
// Konstanter för kalendern
struct CalendarConstants {
    static let dayName = ["Man", "Tir", "Ons", "Tor", "Fre", "Lør", "Søn"]
    
    
   static let currentYear: Int = Calendar.current.component(.year, from: Date())
   static let currentMonth: Int = Calendar.current.component(.month, from: Date())
    
    static let minDate = Calendar.current.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1))!
    // Om jag vill ha årte nu, ocg extra år plus +9 = 10åt i kalendern. Om jag vill ha fler månader kan jag lägga till +11 och då får jag ett år.
    static let maxDate = Calendar.current.date(from: DateComponents(year: currentYear, month: (currentMonth+3)%12, day: 1))! //mod tar tillbaka i range 1-12, (11 + 2) % 12 = 13 % 12 = 1, detta tar oss allstå tillbaka till 1. --NOTE-- viktigt att det går över 12 därför +2 #ingenjörsmatte gör ingen glad=D +5 om du viöl ha fem månader. 
}
