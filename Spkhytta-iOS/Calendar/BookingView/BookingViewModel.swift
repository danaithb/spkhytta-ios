// BookingViewModel.swift
// Calendar
//
// Skapad 10/04/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth
import Combine

class BookingViewModel: ObservableObject {
    // Publicerade egenskaper för vy-bindning
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var numberOfPeople: String = "Antall"
    @Published var isProcessing = false
    @Published var alertInfo: AlertInfo?
    @Published var bookingSuccess = false
    
    // Användarinformation (kan hämtas från en användartjänst)
    @Published var userName: String = "Ola Norman"
    @Published var userMobile: String = "99999999"
    @Published var userEmail: String = "ola.norman@spk.no"
    
    // Struktur för alarmering
    struct AlertInfo {
        var title: String
        var message: String
        var isShowing: Bool = true
    }
    
    // Metod för att validera och bekräfta bokning
    func confirmBooking(completion: @escaping () -> Void) {
        // Valideringslogik
        if numberOfPeople == "Antall" {
            showAlert(title: "Velg antall", message: "Vennligst velg antall personer.")
            return
        }
        
        guard let start = startDate else {
            showAlert(title: "Mangler dato", message: "Vennligst velg start dato.")
            return
        }
        
        // Sätt slutdatum lika med startdatum om det inte är valt (för endagsbokningar)
        let end = endDate ?? start
        
        isProcessing = true
        
        // Anropa API-klienten för att skicka bokningsförfrågan
        BookingAPIClient.shared.sendBookingRequest(
            startDate: start,
            endDate: end,
            numberOfPeople: Int(numberOfPeople) ?? 1
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isProcessing = false
                
                switch result {
                case .success(let response):
                    print("Bokning lyckades: \(response)")
                    self.showAlert(
                        title: "Booking bekreftet",
                        message: "Din booking er bekreftet. Referansenummer: \(response)"
                    )
                    self.bookingSuccess = true
                    
                case .failure(let error):
                    self.handleBookingError(error)
                }
                
                if self.bookingSuccess {
                    completion()
                }
            }
        }
    }
    
    // Hjälpmetod för att hantera bokningsfel
    private func handleBookingError(_ error: BookingAPIClient.BookingError) {
        switch error {
        case .invalidDates:
            showAlert(title: "Ugyldig dato", message: "Vennligst sjekk booking datoene.")
        case .authenticationError:
            showAlert(title: "Autentiseringsfeil", message: "Vennligst logg inn på nytt for å fortsette.")
        case .networkError:
            showAlert(title: "Nettverksfeil", message: "Kunne ikke koble til serveren. Prøv igjen senere.")
        case .serverError(let code):
            showAlert(title: "Serverfeil", message: "Serveren returnerte feilkode: \(code). Prøv igjen senere.")
        case .unknownError:
            showAlert(title: "Feil", message: "En ukjent feil oppstod. Prøv igjen senere.")
        }
    }
    
    // Visa alert hjälpmetod
    func showAlert(title: String, message: String) {
        alertInfo = AlertInfo(title: title, message: message)
    }
    
    // Återställ bokningsdata
    func resetBookingData() {
        startDate = nil
        endDate = nil
        numberOfPeople = "Antall"
        bookingSuccess = false
    }
    
    // Formatera datum för visning med användning av den befintliga Calendar-tillägget
    func formatDate(_ date: Date) -> String {
        return Calendar.dateFormatter.string(from: date)
    }
}
