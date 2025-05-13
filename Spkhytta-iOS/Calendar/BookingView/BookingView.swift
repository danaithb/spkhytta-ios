//  BookingView.swift
//
// Created by Mariana och Abigail on 23/03/2025.

import SwiftUI
import Firebase
import FirebaseAuth

struct BookingView: View {
    @StateObject private var viewModel = BookingViewModel()
    @State private var userInfo: UserInfo?
    @State private var bookingPurpose: String? = "Privat"
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    @Environment(\.dismiss) private var dismiss

    @State private var showBookingConfirmationSheet = false

    var body: some View {
        VStack {
            BookingContentView(
                title: "Kontaktinformasjon",
                contents: [
                    HStack {
                        Text("Navn:")
                            .fontWeight(.bold)
                        Text(userInfo?.name ?? "Laster...")
                    },
                    HStack {
                        Text("E-postadresse:")
                            .fontWeight(.bold)
                        Text(userInfo?.email ?? "Laster...")
                    }
                ]
            )
            .padding(.top, 30)

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
            } else if endDate == nil && startDate != nil {
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
                        .background(Color(.systemBackground))
                        .foregroundColor(.black)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.customGrey, lineWidth: 1)
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                ]
            )

            Text("Hvilken sammenheng ønsker du ta hytta i bruk?")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                .padding(.top)

            HStack(spacing: 20) {
                RadioButton(
                    title: "Jobb",
                    isSelected: bookingPurpose == "Jobb",
                    onTap: {
                        bookingPurpose = "Jobb"
                    }
                )
                .padding(.trailing, 50)

                RadioButton(
                    title: "Privat",
                    isSelected: bookingPurpose == "Privat",
                    onTap: {
                        bookingPurpose = "Privat"
                    }
                )
            }
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 10)

            if viewModel.isProcessing {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                ButtonView(text: "Bekreft Booking")
                    .onTapGesture {
                        viewModel.startDate = startDate
                        viewModel.endDate = endDate
                        viewModel.bookingPurpose = bookingPurpose

                        viewModel.confirmBooking {
                            // Fördröj visning för att undvika krock
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                showBookingConfirmationSheet = true
                            }
                        }
                    }
            }
        }
        .font(.subheadline)
        .padding(.bottom, 20)
        .disabled(viewModel.isProcessing)
        .navigationBarBackButtonHidden(true) // Döljer den automatiska "Back"-knappen
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Tilbake")
                            }
                        }
                    }
                }
        
        .onAppear {
            UserAPIClient.shared.fetchUserInfo { info in
                DispatchQueue.main.async {
                    self.userInfo = info
                }
            }
        }
        .sheet(isPresented: $showBookingConfirmationSheet) {
            BookingConfirmationSheet(
                bookingReference: viewModel.bookingReference,
                onDone: {
                    showBookingConfirmationSheet = false
                    resetAndDismiss()
                }
            )
        }
    }

    private func resetAndDismiss() {
        startDate = nil
        endDate = nil
        viewModel.resetBookingData()
        //dismiss()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            dismiss()
        }
    }
}
