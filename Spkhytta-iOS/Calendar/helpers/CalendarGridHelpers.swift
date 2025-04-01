// CalendarGridHelpers.swift
//  Calendar
//
// Created by Jana Carlsson (datum)

// TODO
// 1. bättre färger för olika tillstånd i kalendern
// 2. lägg till färg för egna bokningar, grön för bekräftad, orange för pending?
// 3. olika färg på passerade datum vs bokade datum, ser likadana ut nu
//4. ändra till de färger Elon bestämy sig för.

import SwiftUI

// ---------- Hjälpfunktioner ----------
struct CalendarGridHelpers {
    // BUG: Samma färg på passerade och bokade datum
    // FIX: Separata färger för passerade och bokade datum
    
    static func backgroundColor(isHoliday: Bool, isUnavailable: Bool, isSelected: Bool,
                             isTodaysDate: Bool) -> Color {
        if isSelected {
            return .blue.opacity(0.3) // valda datum
        } else if isUnavailable {
            return Color.gray.opacity(0.2) // otillgängliga datum
        } else {
            return Color.clear // tillgängliga datum
        }
    }

    static func textColor(isHoliday: Bool, isUnavailable: Bool, isTodaysDate: Bool,
                       isSelected: Bool) -> Color {
        if isUnavailable {
            return .gray // grå text för otillgängliga
        } else if isHoliday {
            return .red // röd text för helgdagar
        } else {
            return .black // svart för vanliga dagar
        }
    }
}
