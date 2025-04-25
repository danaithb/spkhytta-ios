////
////  ProfileView.swift
//// hytte
////
//// Created by Mariana and Abigail on 24/02/2025.
//
//import SwiftUI
//import SwiftData
//import FirebaseAuth
//import Firebase
//
//struct ProfileView: View {
//    @ObservedObject var authViewModel: AuthViewModel
//    @State private var currentUser: User?
//
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 16) {
//                Text("Min side")
//                    .font(.largeTitle)
//                    .bold()
//                    .padding(.top)
//
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
//                        .frame(width: 180, height: 180)
//
//                    Image(systemName: "person.circle.fill")
//                        .resizable()
//                        .foregroundColor(.gray)
//                        .frame(width: 100, height: 100)
//                }
//
//                VStack(spacing: 4) {
//                    // Display user name
//                    Text(authViewModel.user?.name ?? getUserDisplayName())
//                        .font(.title2)
//                        .fontWeight(.semibold)
//
//                    Text("It-Utvikler")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Mine bookinger")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//
//                    VStack(alignment: .leading, spacing: 16) {
//                        HStack {
//                            Text("**Dato:** 03–06-2025")
//                            Spacer()
//                            Text("**Antall personer:** 4")
//                        }
//
//                        VStack(spacing: 8) {
//                            Text("Status på booking:")
//                                .font(.subheadline)
//                                .fontWeight(.semibold)
//
//                            HStack(spacing: 8) {
//                                Text("Bekreftet")
//                                Circle()
//                                    .fill(Color.green)
//                                    .frame(width: 14, height: 14)
//                            }
//                        }
//                        .frame(maxWidth: .infinity, alignment: .center)
//                    }
//                    .padding()
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.gray.opacity(0.5))
//                    )
//                }
//                .padding(.horizontal)
//            }
//            .padding()
//        }
//        .onAppear {
//            if let user = Auth.auth().currentUser {
//                print("ProfileView appeared, Firebase UID: \(user.uid)")
//                user.getIDToken { token, error in
//                    if let token = token {
//                        print("FULL FIREBASE TOKEN IN PROFILE: \(token)")
//                    }
//                }
//            }
//            print("ProfileView appeared, authViewModel.user: \(String(describing: authViewModel.user))")
//            currentUser = authViewModel.user
//        }
//    }
//
//    private func getUserDisplayName() -> String {
//        let email = authViewModel.user?.email ?? ""
//        if !email.isEmpty, let username = email.split(separator: "@").first {
//            return String(username).replacingOccurrences(of: ".", with: " ")
//        }
//        return "Användare"
//    }
//}
//
//
//  ProfileView.swift
// hytte
//
// Created by Mariana and Abigail on 24/02/2025.

import SwiftUI
import SwiftData
import FirebaseAuth
import Firebase

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var currentUser: User?
    @State private var bookings: [BookingInfo] = [] // Lagrar användarens bokningar
    @State private var isLoading = false // För laddningstillstånd
    @State private var errorMessage: String? = nil // För felmeddelanden

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Min side")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        .frame(width: 180, height: 180)

                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 100, height: 100)
                }

                VStack(spacing: 4) {
                    // Display user name
                    Text(authViewModel.user?.name ?? getUserDisplayName())
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("It-Utvikler")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Mine bookinger")
                        .font(.title3)
                        .fontWeight(.semibold)

                    if isLoading {
                        // Visa laddningsindikator medan vi hämtar bokningar
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 100)
                    } else if let error = errorMessage {
                        // Visa felmeddelande om något gick fel
                        Text(error)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else if bookings.isEmpty {
                        // Visa meddelande om användaren inte har några bokningar
                        Text("Du har inga bokningar än")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.5))
                            )
                    } else {
                        // Visa användarens bokningar
                        ForEach(bookings, id: \.id) { booking in
                            BookingCard(booking: booking)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .onAppear {
            if let user = Auth.auth().currentUser {
                print("ProfileView appeared, Firebase UID: \(user.uid)")
                user.getIDToken { token, error in
                    if let token = token {
                        print("FULL FIREBASE TOKEN IN PROFILE: \(token)")
                    }
                }
            }
            print("ProfileView appeared, authViewModel.user: \(String(describing: authViewModel.user))")
            currentUser = authViewModel.user
            
            // Hämta användarens bokningar när vyn visas
            fetchUserBookings()
        }
    }
    
    // Funktion för att hämta användarens bokningar från backend
    private func fetchUserBookings() {
        isLoading = true
        errorMessage = nil
        
        BookingAPIClient.shared.fetchUserBookings { result in
            DispatchQueue.main.async {
                isLoading = false
                
                switch result {
                case .success(let fetchedBookings):
                    self.bookings = fetchedBookings
                case .failure(let error):
                    // Hantera olika typer av fel
                    switch error {
                    case .authenticationError:
                        self.errorMessage = "Inte inloggad. Logga in för att se dina bokningar."
                    case .networkError:
                        self.errorMessage = "Nätverksproblem. Kontrollera din anslutning."
                    case .serverError(let code):
                        self.errorMessage = "Serverfel (\(code)). Försök igen senare."
                    default:
                        self.errorMessage = "Kunde inte hämta bokningar."
                    }
                }
            }
        }
    }
    
    // Komponent för att visa en enskild bokning
    private func BookingCard(booking: BookingInfo) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("**Dato:** \(booking.startDate) – \(booking.endDate)")
                Spacer()
                Text("**Bokning ID:** SPK-\(booking.id)")
            }

            VStack(spacing: 8) {
                Text("Status på booking:")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                HStack(spacing: 8) {
                    Text(getStatusText(booking.status))
                    Circle()
                        .fill(getStatusColor(booking.status))
                        .frame(width: 14, height: 14)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.5))
        )
    }
    
    // Hjälpfunktion för att visa statustext på svenska
    private func getStatusText(_ status: String) -> String {
        switch status.uppercased() {
        case "CONFIRMED":
            return "Bekreftet"
        case "PENDING":
            return "Venter på godkjenning"
        case "QUEUED":
            return "I kø"
        default:
            return status.capitalized
        }
    }
    
    // Hjälpfunktion för att visa rätt färg baserat på status
    private func getStatusColor(_ status: String) -> Color {
        switch status.uppercased() {
        case "CONFIRMED":
            return .green
        case "PENDING":
            return .yellow
        case "QUEUED":
            return .orange
        default:
            return .gray
        }
    }

    private func getUserDisplayName() -> String {
        let email = authViewModel.user?.email ?? ""
        if !email.isEmpty, let username = email.split(separator: "@").first {
            return String(username).replacingOccurrences(of: ".", with: " ")
        }
        return "Användare"
    }
}
