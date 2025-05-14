//
//  Calendar.swift
//  booking
//
//  Created by Mariana  on 18/02/2025.

import Foundation
import SwiftUI

struct CalendarConstants {
    static let dayName = ["Man", "Tir", "Ons", "Tor", "Fre", "Lør", "Søn"]
    
    
   static let currentYear: Int = Calendar.current.component(.year, from: Date())
   static let currentMonth: Int = Calendar.current.component(.month, from: Date())
    
    static let minDate = Calendar.current.date(from: DateComponents(year: currentYear, month: currentMonth, day: 1))!
    // Om vi vill ha år te nå, og extra år plus +9 = 10år i kalendern. Om vi vil ha flere månter kan vi legge til +11 och då får vi ett år.
    static let maxDate = Calendar.current.date(from: DateComponents(year: currentYear, month: (currentMonth+3)%12, day: 1))! //mod tar tillbake i range 1-12, (11 + 2) % 12 = 13 % 12 = 1,
}
