//  BookingView.swift
//
// Created by Mariana och Abigail on 23/03/2025.
//
// TODO
//1. lägg till så att det bara visas ett datum i mitten om personen bara bokar ett datum. --fixat
// 2. ska man ha med referens nummer här? får man inte det när man har bekräftat bokningen? --fixat
// 3. till Elin, ser det bättre ut om de datum som är nu ligger närmare om det bara ska visas ett datum? det ser nog väldigt rart ut om de ligger långt från sen blir det bara ett datum där pilen är nu. DONE
//4. varför en avbryt knapp, den pilen tar dig tillbaka till kalendern och avbryter allt. FÅTT SVAR PÅ
// 5. vad ska vara i den tredje framen som är tom på prototype varsion 2? FÅTT SVAR OP
//6. Kan menyn doppa upp. när den droppar ner så får den inte plats. FÅTT SVAR PÅ
//till gruppen,ska man kunna boka bara en dag, eller måste det vara en natt också? DONE
//lägg till error om man inte har tryckt på ett datum. DONE
//id ska genereras mfrån backend. så ta bort den här.


import SwiftUI
import Firebase
import FirebaseAuth
import SwiftData

struct BookingView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel: BookingViewModel
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    @Environment(\.dismiss) private var dismiss

    init(startDate: Binding<Date?>, endDate: Binding<Date?>, modelContext: ModelContext) {
        self._startDate = startDate
        self._endDate = endDate
        _viewModel = StateObject(wrappedValue: BookingViewModel(modelContext: modelContext))
    }

    var body: some View {
        VStack {
            // Kontaktinformation
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
            
            // Valda datum
            if endDate != nil && startDate != nil {
                BookingContentView(
                    title: "Valgt dato",
                    subtitle: "Dine valgte datoer",
                    contents: [
                        HStack {
                            Spacer()
                            
                            if let start = startDate {
                                Text("\(start, formatter: Calendar.dateFormatter)")
                                    .padding(.trailing, 10)
                            }
                            Text("-")
                                .padding(.trailing, 10)
                            if let end = endDate {
                                Text("\(end, formatter: Calendar.dateFormatter)")
                            }
                            Spacer()
                        }
                    ]
                )
            }
            else if endDate == nil && startDate != nil {
                // För ett-dags booking, centrerat
                BookingContentView(
                    title: "Valgt dato",
                    subtitle: "Dine valgte datoer",
                    contents: [
                        HStack {
                            if let start = startDate {
                                Text("\(start, formatter: Calendar.dateFormatter)")
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    ]
                )
            }
            
            // Antal personer
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
                    viewModel.startDate = startDate
                    viewModel.endDate = endDate
                    
                    viewModel.confirmBooking {
                        resetAndDismiss()
                    }
                }
            }
        }
        .font(.subheadline)
        .padding(.bottom, 20)
        .alert(
            viewModel.alertInfo?.title ?? "",
            isPresented: .constant(viewModel.alertInfo != nil),
            actions: {
                Button("OK") {
                    if viewModel.bookingSuccess {
                        resetAndDismiss()
                    }
                    viewModel.alertInfo = nil
                }
            },
            message: {
                Text(viewModel.alertInfo?.message ?? "")
            }
        )
        .disabled(viewModel.isProcessing)
        .onAppear {
            // Uppdatera viewModeln med användardata från authViewModel
            viewModel.userName = authViewModel.user?.name ?? viewModel.userName
            viewModel.userEmail = authViewModel.user?.email ?? viewModel.userEmail
            print("Updated booking view with user: \(viewModel.userName)")
        }
    }
    
    private func resetAndDismiss() {
        startDate = nil
        endDate = nil
        viewModel.resetBookingData()
        dismiss()
    }
}
