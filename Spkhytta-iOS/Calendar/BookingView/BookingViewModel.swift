//BookingViewModel
//Created by Mariana och Abigail on 23/03/2025.
//TODO:
//Ska vi ha med en alert som visar bokningsreferansen, om inte ta bort den som är på rad 67
//ändra så att start dato kommer först. så end date. så antal personer.


// BookingViewModel.swift
// Created by Mariana och Abigail on 23/03/2025.



       
//import SwiftUI
//import Firebase
//import FirebaseAuth
//import SwiftData
//
//@MainActor
//class BookingViewModel: ObservableObject {
//    @Published var startDate: Date?
//    @Published var endDate: Date?
//    @Published var numberOfPeople: String = "Antall"
//
//    // Användarinformation
//    @Published var userName: String = ""
//    @Published var userMobile: String = "+46 70 123 45 67"
//    @Published var userEmail: String = ""
//
//    @Published var isProcessing = false
//    @Published var alertInfo: AlertInfo?
//    @Published var bookingSuccess = false
//
//    private let userStorage: UserStorage
//
//    struct AlertInfo {
//        let title: String
//        let message: String
//    }
//
//    init(modelContext: ModelContext) {
//        self.userStorage = UserStorage(modelContext: modelContext)
//        loadUserInfo()
//    }
//
//    private func loadUserInfo() {
//        // Använd bara standard-information tills onAppear uppdaterar med korrekt data
//        if let currentUser = Auth.auth().currentUser {
//            print("Setting default user info until updated from AuthViewModel")
//            self.userEmail = currentUser.email ?? ""
//            self.userName = currentUser.displayName ?? currentUser.email?.split(separator: "@").first.map(String.init) ?? "Användare"
//        } else {
//            print("No current Firebase user, using default data")
//            self.userName = "Ola Norman"
//            self.userEmail = "ola.norman@spk.no"
//        }
//    }
//
//    func formatDate(_ date: Date) -> String {
//        return Calendar.dateFormatter.string(from: date)
//    }
//
//    func confirmBooking(onSuccess: @escaping () -> Void) {
//        if numberOfPeople == "Antall" {
//            showAlert(title: "Velg antall", message: "Vennligst velg antall personer.")
//            return
//        }
//
//        guard let start = startDate else {
//            showAlert(title: "Mangler dato", message: "Vennligst velg start dato.")
//            return
//        }
//
//        let end = endDate ?? start
//        isProcessing = true
//        print("Sending booking request - start: \(start), end: \(end), people: \(numberOfPeople)")
//
//        BookingAPIClient.shared.sendBookingRequest(
//            startDate: start,
//            endDate: end,
//            numberOfPeople: Int(numberOfPeople) ?? 1
//        ) { [weak self] result in
//            guard let self = self else { return }
//
//            DispatchQueue.main.async {
//                self.isProcessing = false
//
//                switch result {
//                case .success(let response):
//                    print("Booking succeeded: \(response)")
//                    self.showAlert(
//                        title: "Booking bekreftet",
//                        message: "Din booking er bekreftet. Referansenummer: \(response)"
//                    )
//                    self.bookingSuccess = true
//                    onSuccess()
//                case .failure(let error):
//                    print("Booking failed: \(error)")
//                    self.handleBookingError(error)
//                }
//            }
//        }
//    }
//
//    private func handleBookingError(_ error: BookingAPIClient.BookingError) {
//        switch error {
//        case .invalidDates:
//            showAlert(title: "Ugyldig dato", message: "Vennligst sjekk booking datoene.")
//        case .authenticationError:
//            showAlert(title: "Autentiseringsfeil", message: "Vennligst logg inn på nytt for å fortsette.")
//        case .networkError:
//            showAlert(title: "Nettverksfeil", message: "Kunne ikke koble til serveren. Prøv igjen senere.")
//        case .serverError(let code):
//            showAlert(title: "Serverfeil", message: "Serveren returnerte feilkode: \(code). Prøv igjen senere.")
//        case .unknownError:
//            showAlert(title: "Feil", message: "En ukjent feil oppstod. Prøv igjen senere.")
//        }
//    }
//
//    private func showAlert(title: String, message: String) {
//        alertInfo = AlertInfo(title: title, message: message)
//    }
//
//    func resetBookingData() {
//        startDate = nil
//        endDate = nil
//        numberOfPeople = "Antall"
//        bookingSuccess = false
//        alertInfo = nil
//    }
//}
//BookingViewModel
//Created by Mariana och Abigail on 23/03/2025.
//TODO:
//Ska vi ha med en alert som visar bokningsreferansen, om inte ta bort den som är på rad 67
//ändra så att start dato kommer först. så end date. så antal personer.


// BookingViewModel.swift
// Created by Mariana och Abigail on 23/03/2025.



       
import SwiftUI
import Firebase
import FirebaseAuth
import SwiftData

@MainActor
class BookingViewModel: ObservableObject {
    @Published var startDate: Date?
    @Published var endDate: Date?
    @Published var numberOfPeople: String = "Antall"
    
    // Användarinformation
    @Published var userName: String = ""
    @Published var userMobile: String = "+46 70 123 45 67"
    @Published var userEmail: String = ""
    
    @Published var isProcessing = false
    @Published var alertInfo: AlertInfo?
    @Published var bookingSuccess = false

    private let userStorage: UserStorage

    struct AlertInfo {
        let title: String
        let message: String
    }

    init(modelContext: ModelContext) {
        self.userStorage = UserStorage(modelContext: modelContext)
        loadUserInfo()
    }

    private func loadUserInfo() {
        // Använd bara standard-information tills onAppear uppdaterar med korrekt data
        if let currentUser = Auth.auth().currentUser {
            print("Setting default user info until updated from AuthViewModel")
            self.userEmail = currentUser.email ?? ""
            self.userName = currentUser.displayName ?? currentUser.email?.split(separator: "@").first.map(String.init) ?? "Användare"
        } else {
            print("No current Firebase user, using default data")
            self.userName = "Ola Norman"
            self.userEmail = "ola.norman@spk.no"
        }
    }

    func formatDate(_ date: Date) -> String {
        return Calendar.dateFormatter.string(from: date)
    }

    func confirmBooking(onSuccess: @escaping () -> Void) {
        if numberOfPeople == "Antall" {
            showAlert(title: "Velg antall", message: "Vennligst velg antall personer.")
            return
        }

        guard let start = startDate else {
            showAlert(title: "Mangler dato", message: "Vennligst velg start dato.")
            return
        }

        let end = endDate ?? start
        isProcessing = true
        print("Sending booking request - start: \(start), end: \(end), people: \(numberOfPeople)")

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
                    
                    // Här extraherar vi referensnummer eller bokning ID från svaret
                    var referenceOrId = "SPK-" // Standard prefix
                    
                    // Om svaret innehåller JSON
                    if response.contains("{") && response.contains("}") {
                        if let data = response.data(using: .utf8),
                           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                           
                            // Försök hitta 'id' först (Spring Boot format)
                            if let id = json["id"] as? Int {
                                referenceOrId += "\(id)"
                            }
                            // Sen leta efter 'reference' (om det finns)
                            else if let reference = json["reference"] as? String {
                                referenceOrId = reference
                            }
                        }
                    } else if let idNumber = Int(response) {
                        // Om svaret bara är ett nummer
                        referenceOrId += "\(idNumber)"
                    } else {
                        // Använd hela svaret som referens
                        referenceOrId = response
                    }
                    
                    self.showAlert(
                        title: "Booking bekreftet",
                        message: "Din booking er bekreftet. Referansenummer: \(referenceOrId)"
                    )
                    self.bookingSuccess = true
                    
                    // Meddela profilvyn att uppdatera bokningslistan
                    NotificationCenter.default.post(name: NSNotification.Name("BookingUpdated"), object: nil)
                    
                    onSuccess()
                case .failure(let error):
                    print("Booking failed: \(error)")
                    self.handleBookingError(error)
                }
            }
        }
    }

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

    private func showAlert(title: String, message: String) {
        alertInfo = AlertInfo(title: title, message: message)
    }

    func resetBookingData() {
        startDate = nil
        endDate = nil
        numberOfPeople = "Antall"
        bookingSuccess = false
        alertInfo = nil
    }
}

