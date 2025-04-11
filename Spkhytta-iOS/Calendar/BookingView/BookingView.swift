////  BookingView.swift
//// Calendar
////
//// Created by Mariana och Abigail on 23/03/2025.
//// Updated on 09/04/2025.
////
//
//// TODO
//// 1. lägg till så att det bara visas ett datum i mitten om personen bara bokar ett datum. --fixat
//// 2. ska man ha med referens nummer här? får man inte det när man har bekräftat bokningen? --fixat
//// 3. till Elin, ser det bättre ut om de datum som är nu ligger närmare om det bara ska visas ett datum? det ser nog väldigt rart ut om de ligger långt från sen blir det bara ett datum där pilen är nu. DONE
//// 4. varför en avbryt knapp, den pilen tar dig tillbaka till kalendern och avbryter allt. FÅTT SVAR PÅ
//// 5. vad ska vara i den tredje framen som är tom på prototype varsion 2? FÅTT SVAR OP
//// 6. Kan menyn doppa upp. när den droppar ner så får den inte plats. FÅTT SVAR PÅ
//
//till gruppen,ska man kunna boka bara en dag, eller måste det vara en natt också? DONE
//
//lägg till error om man inte har tryckt på ett datum. DONE
////id ska genereras mfrån backend. så ta bort den här.
//
//import SwiftUI
//import Firebase
//import FirebaseAuth
//
//// ---------- Bokningsvy ----------
//struct BookingView: View {
//    @Binding var startDate: Date?
//    @Binding var endDate: Date?
//    @Environment(\.dismiss) private var dismiss
//    @State private var numberOfPeople: String = "Antall"
//    
//    // States för att hantera bokningsprocessen
//    @State private var isProcessing = false
//    @State private var showAlert = false
//    @State private var alertTitle = ""
//    @State private var alertMessage = ""
//    @State private var bookingSuccess = false
//    
//    var body: some View {
//        VStack {
//            BookingContentView(
//                title: "Kontaktinformasjon",
//                contents: [
//                    HStack {
//                        Text("Navn:")
//                            .fontWeight(.bold)
//                        Text("Ola Norman")
//                    },
//                    
//                    HStack {
//                        Text("Mobil:")
//                            .fontWeight(.bold)
//                        Text("99999999")
//                    },
//                    HStack {
//                        Text("E-postadresse:")
//                            .fontWeight(.bold)
//                        Text("ola.norman@spk.no")
//                    }
//                ]
//            )
//            .padding(.top, 30)
//            
//            // ---------- Valda datum ----------
//            if endDate != nil && startDate != nil {
//                BookingContentView(
//                    title: "Valgt dato",
//                    subtitle: "Dine valgte datoer",
//                    contents: [
//                        HStack {
//                            Spacer()
//                            
//                            if let start = startDate {
//                                Text("\(start, formatter: Calendar.dateFormatter)")
//                                    .padding(.trailing, 10)
//                            }
//                            Text("-")
//                                .padding(.trailing, 10)
//                            if let end = endDate {
//                                Text("\(end, formatter: Calendar.dateFormatter)")
//                            }
//                            Spacer()
//                        }
//                    ]
//                )
//            }
//            else if endDate == nil && startDate != nil {
//                // för ett-dags booking, centrerat
//                BookingContentView(
//                    title: "Valgt dato",
//                    subtitle: "Dine valgte datoer",
//                    contents: [
//                        HStack {
//                            if let start = startDate {
//                                Text("\(start, formatter: Calendar.dateFormatter)")
//                                    .frame(maxWidth: .infinity, alignment: .center)
//                            }
//                        }
//                    ]
//                )
//            }
//            
//            // ---------- Antal personer ----------
//            BookingContentView(
//                title: "Antall personer",
//                subtitle: "Hvor mange ønsker du ta med",
//                contents: [
//                    Menu {
//                        ForEach(1...8, id: \.self) { number in
//                            Button("\(number)") {
//                                numberOfPeople = "\(number)"
//                            }
//                        }
//                    } label: {
//                        HStack {
//                            Text(numberOfPeople)
//                            Spacer()
//                            Image(systemName: "chevron.down")
//                        }
//                        .padding()
//                        .frame(maxWidth: 200)
//                        .background(Color.white)
//                        .foregroundColor(.black)
//                        .cornerRadius(5)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 5)
//                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
//                        )
//                    }
//                    .frame(maxWidth: .infinity, alignment: .center)
//                ]
//            )
//            Spacer()
//            
//            // Bekräfta bokning knapp
//            if isProcessing {
//                ProgressView()
//                    .progressViewStyle(CircularProgressViewStyle())
//                    .padding()
//            } else {
//                ButtonView(
//                    text: "Bekreft Booking"
//                )
//                .onTapGesture {
//                    confirmBooking()
//                }
//            }
//        }
//        .font(.subheadline)
//        .padding(.bottom, 20) //bra höjd för att man ska kunna trycka med tummen på knappen.
//        .alert(isPresented: $showAlert) {
//            Alert(
//                title: Text(alertTitle),
//                message: Text(alertMessage),
//                dismissButton: .default(Text("OK")) {
//                    if bookingSuccess {
//                        resetAndDismiss()
//                    }
//                }
//            )
//        }
//        .disabled(isProcessing)
//    }
//    
//    // Ny funktion för att hantera bokningsbekräftelse
//    private func confirmBooking() {
//        if numberOfPeople == "Antall" {
//            showAlert(title: "Velg antall", message: "Vennligst velg antall personer.", success: false)
//            return
//        }
//        
//        guard let start = startDate else {
//            showAlert(title: "Mangler dato", message: "Vennligst velg start dato.", success: false)
//            return
//        }
//        
//        // Sätt slut datum lika med start datum om det inte är valt (för en dags booking)
//        let end = endDate ?? start
//        
//        isProcessing = true
//        
//        // Anropa API-klienten för att skicka bokningsförfrågan
//        BookingAPIClient.shared.sendBookingRequest(
//            startDate: start,
//            endDate: end,
//            numberOfPeople: Int(numberOfPeople) ?? 1
//        ) { result in
//            DispatchQueue.main.async {
//                isProcessing = false
//                
//                switch result {
//                case .success(let response):
//                    print("Bokning lyckades: \(response)")
//                    showAlert(
//                        title: "Booking bekreftet",
//                        message: "Din booking er bekreftet. Referansenummer: \(response)",
//                        success: true
//                    )
//                    
//                case .failure(let error):
//                    handleBookingError(error)
//                }
//            }
//        }
//    }
//    
//    private func handleBookingError(_ error: BookingAPIClient.BookingError) {
//        switch error {
//        case .invalidDates:
//            showAlert(title: "Ugyldig dato", message: "Vennligst sjekk booking datoene.", success: false)
//        case .authenticationError:
//            showAlert(title: "Autentiseringsfeil", message: "Vennligst logg inn på nytt for å fortsette.", success: false)
//        case .networkError:
//            showAlert(title: "Nettverksfeil", message: "Kunne ikke koble til serveren. Prøv igjen senere.", success: false)
//        case .serverError(let code):
//            showAlert(title: "Serverfeil", message: "Serveren returnerte feilkode: \(code). Prøv igjen senere.", success: false)
//        case .unknownError:
//            showAlert(title: "Feil", message: "En ukjent feil oppstod. Prøv igjen senere.", success: false)
//        }
//    }
//    
//    private func showAlert(title: String, message: String, success: Bool) {
//        alertTitle = title
//        alertMessage = message
//        bookingSuccess = success
//        showAlert = true
//    }
//    
//    private func resetAndDismiss() {
//        startDate = nil
//        endDate = nil
//        dismiss()
//    }
//}
// BookingView.swift
// Calendar
//
// Created by Mariana och Abigail on 23/03/2025.
// Updated on 10/04/2025.
//

// BookingView.swift
// Calendar
//
// Skapad av Mariana och Abigail 23/03/2025.
// Uppdaterad 10/04/2025.
//

import SwiftUI
import Firebase
import FirebaseAuth

// ---------- Bokningsvy ----------
struct BookingView: View {
    @StateObject private var viewModel: BookingViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Initialisera med optional binding datum
    init(startDate: Binding<Date?>, endDate: Binding<Date?>) {
        let vm = BookingViewModel()
        _viewModel = StateObject(wrappedValue: vm)
        
        // Sätt initiala datum från bindnings
        if let start = startDate.wrappedValue {
            vm.startDate = start
        }
        if let end = endDate.wrappedValue {
            vm.endDate = end
        }
    }
    
    var body: some View {
        VStack {
            // ---------- Kontaktinformation ----------
            BookingContentView(
                title: "Kontaktinformasjon",
                contents: [
                    HStack {
                        Text("Navn:")
                            .fontWeight(.bold)
                        Text(viewModel.userName)
                    },
                    
                    HStack {
                        Text("Mobil:")
                            .fontWeight(.bold)
                        Text(viewModel.userMobile)
                    },
                    HStack {
                        Text("E-postadresse:")
                            .fontWeight(.bold)
                        Text(viewModel.userEmail)
                    }
                ]
            )
            .padding(.top, 30)
            
            // ---------- Valda datum ----------
            if viewModel.endDate != nil && viewModel.startDate != nil {
                BookingContentView(
                    title: "Valgt dato",
                    subtitle: "Dine valgte datoer",
                    contents: [
                        HStack {
                            Spacer()
                            
                            if let start = viewModel.startDate {
                                Text(viewModel.formatDate(start))
                                    .padding(.trailing, 10)
                            }
                            Text("-")
                                .padding(.trailing, 10)
                            if let end = viewModel.endDate {
                                Text(viewModel.formatDate(end))
                            }
                            Spacer()
                        }
                    ]
                )
            }
            else if viewModel.endDate == nil && viewModel.startDate != nil {
                // För ett-dags booking, centrerat
                BookingContentView(
                    title: "Valgt dato",
                    subtitle: "Dine valgte datoer",
                    contents: [
                        HStack {
                            if let start = viewModel.startDate {
                                Text(viewModel.formatDate(start))
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    ]
                )
            }
            
            // ---------- Antal personer ----------
            BookingContentView(
                title: "Antall personer",
                subtitle: "Hvor mange ønsker du ta med",
                contents: [
                    Menu {
                        ForEach(1...8, id: \.self) { number in
                            Button("\(number)") {
                                viewModel.numberOfPeople = "\(number)"
                            }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.numberOfPeople)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                ]
            )
            Spacer()
            
            // Bekräfta bokning knapp
            if viewModel.isProcessing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                ButtonView(
                    text: "Bekreft Booking"
                )
                .onTapGesture {
                    viewModel.confirmBooking {
                        resetAndDismiss()
                    }
                }
            }
        }
        .font(.subheadline)
        .padding(.bottom, 20) // Bra höjd för att man ska kunna trycka med tummen på knappen.
        .alert(
            viewModel.alertInfo?.title ?? "",
            isPresented: .constant(viewModel.alertInfo != nil),
            actions: {
                Button("OK") {
                    viewModel.alertInfo = nil
                    if viewModel.bookingSuccess {
                        resetAndDismiss()
                    }
                }
            },
            message: {
                Text(viewModel.alertInfo?.message ?? "")
            }
        )
        .disabled(viewModel.isProcessing)
    }
    
    private func resetAndDismiss() {
        viewModel.resetBookingData()
        dismiss()
    }
}

// Preview-leverantör kan läggas till här om det behövs
#Preview {
    BookingView(
        startDate: .constant(Date()),
        endDate: .constant(Date().addingTimeInterval(86400))
    )
}
