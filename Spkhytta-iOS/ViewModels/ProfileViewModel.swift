//
//  ProfileViewModel.swift
//  Spkhytta-iOS
//
//  Created by Jana Carlsson on 08/05/2025.
//

import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userInfo: UserInfo?
    @Published var bookings: [BookingSummary] = []
    
    func fetchData() {
        fetchUserInfo()
        fetchBookings()
    }
    
    private func fetchUserInfo() {
        UserAPIClient.shared.fetchUserInfo { [weak self] info in
            DispatchQueue.main.async {
                self?.userInfo = info
            }
        }
    }
    
    private func fetchBookings() {
        UserAPIClient.shared.fetchBookingSummaries { [weak self] summaries in
            DispatchQueue.main.async {
                self?.bookings = summaries
            }
        }
    }
    
    func localizedStatus(_ status: String) -> String {
        switch status.lowercased() {
        case "confirmed":
            return "Bekreftet"
        case "pending":
            return "Venter på trekning"
        case "canceled":
            return "Kansellert"
        default:
            return status
        }
    }
    
    func parsedQuarantineDate() -> Date? {
        guard let dateString = userInfo?.quarantineEndDate else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }

}
