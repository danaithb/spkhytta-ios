//
// CalendarGridHelpers.swift
//  Calendar
//
// Created by Mariana och Abigail 23/03/2025


import SwiftUI

// ---------- Hjälpfunktioner ----------
struct CalendarGridHelpers {
    
    
    static func backgroundColor(isHoliday: Bool, isUnavailable: Bool, isSelected: Bool,
                             isTodaysDate: Bool) -> Color {
        if isSelected {
            return Color.lightBlue
        } else if isUnavailable {
            return Color.bookedGrey
        } else {
            return Color.clear
        }
    }

    static func textColor(isHoliday: Bool, isUnavailable: Bool, isTodaysDate: Bool,
                       isSelected: Bool) -> Color {
        if isUnavailable {
            return .gray
        } else if isHoliday {
            return .redDays
        } else {
            return .primary
        }
    }
}
