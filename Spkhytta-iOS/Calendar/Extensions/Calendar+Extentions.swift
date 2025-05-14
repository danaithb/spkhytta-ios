//
//  Calendar+Extensions.swift
//  booking
//
//  Created by Created by Mariana och Abigail on 03/02/2025. Fått hjelp av Danial på SPK


import Foundation

extension Calendar {
    static let monthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "nb_NO")
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "nb_NO")
        return formatter
    }()
    
    static let holidayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
