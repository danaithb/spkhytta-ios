// CalendarGridHelpers.swift
//  Calendar
//
// Created by Mariana och Abigail 23/03/2025


import SwiftUI

// ---------- Hjälpfunktioner ----------
struct CalendarGridHelpers {
    // BUG: Samma färg på passerade och bokade datum
    // FIX: Separata färger för passerade och bokade datum
    
    static func backgroundColor(isHoliday: Bool, isUnavailable: Bool, isSelected: Bool,
                             isTodaysDate: Bool) -> Color {
        if isSelected {
            return Color.lightBlue  // valda datum
        } else if isUnavailable {
            return Color.bookedGrey // otillgängliga datum
        } else {
            return Color.clear // tillgängliga datum
        }
    }

    static func textColor(isHoliday: Bool, isUnavailable: Bool, isTodaysDate: Bool,
                       isSelected: Bool) -> Color {
        if isUnavailable {
            return .gray // grå text för otillgängliga
        } else if isHoliday {
            return .redDays // röd text för helgdagar
        } else {
            return .primary // svart för vanliga dagar
        }
    }
}
