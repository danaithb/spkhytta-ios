////
////  ProfileViewModel.swift
////  Spkhytta-iOS
////
////  Created by Jana Carlsson on 23/04/2025.
////
//
////  ProfileViewModel.swift
////  Spkhytta
////
////  Created by Mariana and Abigail on 21/02/2025.
//
//// ProfileViewModel.swift
//import Foundation
//import SwiftUI
//
//@MainActor
//class ProfileViewModel: ObservableObject {
//    @Published var bookings: [BookingInfo] = []
//
//    func fetchUserBookings() async {
//        do {
//            let result = try await BookingAPIClient.shared.fetchUserBookings()
//            bookings = result
//        } catch {
//            print("Failed to fetch bookings: \(error)")
//        }
//    }
//
//    func formatDate(_ dateString: String) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        if let date = formatter.date(from: dateString) {
//            formatter.dateStyle = .medium
//            return formatter.string(from: date)
//        }
//        return dateString
//    }
//
//    func getStatusText(_ status: String) -> String {
//        switch status {
//        case "confirmed": return "Bekreftet"
//        case "pending": return "Venter"
//        case "cancelled": return "Avbrutt"
//        default: return status.capitalized
//        }
//    }
//
//    func statusColor(_ status: String) -> Color {
//        switch status {
//        case "confirmed": return .green
//        case "pending": return .orange
//        case "cancelled": return .red
//        default: return .gray
//        }
//    }
//
//    func getUserDisplayName(from email: String?) -> String {
//        guard let email = email else { return "Ukjent bruker" }
//        let parts = email.split(separator: "@")
//        return parts.first.map { String($0).capitalized } ?? email
//    }
//}
