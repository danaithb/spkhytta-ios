
//BookingViewModel
//Created by Mariana och Abigail on 23/03/2025.
// TODO:
//Ska vi ha med en alert som visar bokningsreferansen, om inte ta bort den som är på rad 67
//ändra så att start dato kommer först. så end date. så antal personer.
import SwiftUI
import Firebase
import FirebaseAuth

class BookingViewModel: ObservableObject {
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var numberOfPeople: String = "Antall"
    
    // User information (in a real app, this would come from user profile)
    @Published var userName: String = "Ola Norman"
    //@Published var userMobile: String = "99999999"
    @Published var userEmail: String = "ola.norman@spk.no"
    
    // States for handling booking process
    @Published var isProcessing = false
    @Published var alertInfo: AlertInfo?
    @Published var bookingSuccess = false
    
    struct AlertInfo {
        let title: String
        let message: String
    }
    
    // Format date using the Calendar extension
    func formatDate(_ date: Date) -> String {
        return Calendar.dateFormatter.string(from: date)
    }
    
    // Function to handle booking confirmation
    func confirmBooking(onSuccess: @escaping () -> Void) {
        if numberOfPeople == "Antall" {
            showAlert(title: "Velg antall", message: "Vennligst velg antall personer.")
            return
        }
        
        guard let start = startDate else {
            showAlert(title: "Mangler dato", message: "Vennligst velg start dato.")
            return
        }
        
        // Set end date equal to start date if not selected (for single day booking)
        let end = endDate ?? start
        
        isProcessing = true
        
        // Call the API client to send booking request
        BookingAPIClient.shared.sendBookingRequest(
            startDate: start,
            endDate: end,
            numberOfPeople: Int(numberOfPeople) ?? 1
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isProcessing = false
                
                switch result {
                case .success(let response):
                    print("Booking succeeded: \(response)")
                    self.showAlert(
                        title: "Booking bekreftet",
                        message: "Din booking er bekreftet. Referansenummer: \(response)"
                    )
                    self.bookingSuccess = true
                    onSuccess()
                    
                case .failure(let error):
                    self.handleBookingError(error)
                }
            }
        }
    }
    
    // Handle different types of booking errors
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
    
    // Helper function to show alerts
    private func showAlert(title: String, message: String) {
        alertInfo = AlertInfo(title: title, message: message)
    }
    
    // Reset booking data
    func resetBookingData() {
        startDate = nil
        endDate = nil
        numberOfPeople = "Antall"
        bookingSuccess = false
        alertInfo = nil
    }
}
