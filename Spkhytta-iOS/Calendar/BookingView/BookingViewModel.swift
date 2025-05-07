
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
    
    // Brukerinformasjon (hardkodet foreløpig)
    @Published var userName: String = "Ola Norman"
    //@Published var userMobile: String = "99999999"
    @Published var userEmail: String = "ola.norman@spk.no"
    
    // State for bookingprosess
    @Published var isProcessing = false
    @Published var alertInfo: AlertInfo?
    @Published var bookingSuccess = false
    @Published var unavailableDates: [String] = []
    
    struct AlertInfo {
        let title: String
        let message: String
    }
    
    // Formatter dato for visning
    func formatDate(_ date: Date) -> String {
        return Calendar.dateFormatter.string(from: date)
    }
    
    func loadAvailability(forMonth month: String, cabinId: Int) {
        guard let user = Auth.auth().currentUser else { return }

        user.getIDToken { token, error in
            if let token = token {
                guard let url = URL(string: "https://hytteportalen-307333592311.europe-west1.run.app/api/calendar/availability") else {
                    print("Ugyldig URL for kalender")
                    return
                }

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                let body: [String: Any] = [
                    "month": month,     // f.eks. "2025-05"
                    "cabinId": cabinId
                ]

                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

                URLSession.shared.dataTask(with: request) { data, _, _ in
                    guard let data = data else { return }
                    do {
                        let result = try JSONDecoder().decode([DayAvailability].self, from: data)
                        DispatchQueue.main.async {
                            self.unavailableDates = result
                                .filter { $0.status == "booked" }
                                .map { $0.date }
                        }
                    } catch {
                        print("Feil ved parsing: \(error)")
                    }
                }.resume()
            }
        }
    }

    // Funksjon for å bekrefte booking
    func confirmBooking(onSuccess: @escaping () -> Void) {
        if numberOfPeople == "Antall" {
            showAlert(title: "Velg antall", message: "Vennligst velg antall personer.")
            return
        }
        
        guard let start = startDate else {
            showAlert(title: "Mangler dato", message: "Vennligst velg startdato.")
            return
        }
        
        // Hvis sluttid ikke er valgt, bruker vi samme som start
        let end = endDate ?? start
        let guests = Int(numberOfPeople) ?? 1
        let cabinId = 1 // TODO: Gjør dynamisk når du har flere hytter

        isProcessing = true
        
        // Kall backend for å opprette booking
        BookingAPIClient.shared.sendBookingRequest(
            cabinId: cabinId,
            startDate: start,
            endDate: end,
            numberOfPeople: guests
        ) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isProcessing = false
                
                switch result {
                case .success(let response):
                    print("[BookingViewModel] Booking bekreftet: \(response)")
                    self.showAlert(
                        title: "Booking bekreftet",
                        message: "Din booking er registrert. \(response)"
                    )
                    self.bookingSuccess = true
                    onSuccess()
                    
                case .failure(let error):
                    self.handleBookingError(error)
                }
            }
        }
    }
    
    // Håndter ulike typer feil
    private func handleBookingError(_ error: BookingAPIClient.BookingError) {
        switch error {
        case .invalidDates:
            showAlert(title: "Ugyldig dato", message: "Vennligst sjekk bookingdatoene.")
        case .authenticationError:
            showAlert(title: "Autentiseringsfeil", message: "Logg inn på nytt for å fortsette.")
        case .networkError:
            showAlert(title: "Nettverksfeil", message: "Kunne ikke koble til serveren.")
        case .serverError(let code):
            showAlert(title: "Serverfeil", message: "Serveren svarte med feilkode: \(code).")
        case .unknownError:
            showAlert(title: "Feil", message: "En ukjent feil oppstod.")
        }
    }
    
    // Vis varsel
    private func showAlert(title: String, message: String) {
        alertInfo = AlertInfo(title: title, message: message)
    }
    
    // Nullstill bookingdata
    func resetBookingData() {
        startDate = nil
        endDate = nil
        numberOfPeople = "Antall"
        bookingSuccess = false
        alertInfo = nil
    }
}
