
//BookingViewModel
//Created by Mariana och Abigail on 23/03/2025.

import SwiftUI
import Firebase
import FirebaseAuth

class BookingViewModel: ObservableObject {
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var numberOfPeople: String = "Antall"
    @Published var bookingPurpose: String? = "Privat"
    
    @Published var userName: String = "Ola Norman"
    @Published var userEmail: String = "ola.norman@spk.no"
    
    @Published var isProcessing = false
    @Published var bookingSuccess = false
    @Published var unavailableDates: [String] = []
    @Published var bookingReference: String = ""

    func confirmBooking(onSuccess: @escaping () -> Void) {
        if numberOfPeople == "Antall" {
            print("Feil: Vennligst velg antall personer.")
            return
        }

        guard let start = startDate else {
            print("Feil: Vennligst velg startdato.")
            return
        }

        let end = endDate ?? start
        let guests = Int(numberOfPeople) ?? 1
        let cabinId = 1

        isProcessing = true

        BookingAPIClient.shared.sendBookingRequest(
            cabinId: cabinId,
            startDate: start,
            endDate: end,
            numberOfPeople: guests,
            bookingPurpose: bookingPurpose
        ) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.isProcessing = false

                switch result {
                case .success(let response):
                    print("Booking bekreftet. Din booking er registrert. \(response)")
                    self.bookingSuccess = true
                    onSuccess()

                case .failure(let error):
                    self.handleBookingError(error)
                }
            }
        }
    }

    private func handleBookingError(_ error: BookingAPIClient.BookingError) {
        switch error {
        case .invalidDates:
            print("Ugyldig dato: Vennligst sjekk bookingdatoene.")
        case .authenticationError:
            print("Autentiseringsfeil: Logg inn på nytt for å fortsette.")
        case .networkError:
            print("Nettverksfeil: Kunne ikke koble til serveren.")
        case .serverError(let code):
            print("Serverfeil: Serveren svarte med feilkode: \(code).")
        case .unknownError:
            print("Feil: En ukjent feil oppstod.")
        }
    }

    func resetBookingData() {
        startDate = nil
        endDate = nil
        numberOfPeople = "Antall"
        bookingPurpose = nil
        bookingSuccess = false
    }
}
