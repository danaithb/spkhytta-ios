//
//CalendarView.swift

//Created by Mariana and Abigail on 28/02/2025

// BUG: Problem med datumval - första gången jag trycker på dagens datum och avmarkerar det kan jag inte välja 31:a. Om jag går till en ny månad fungerar det igen. Dagens datum fungerar med 31:a, så det är bara första gången. Klicken registreras korrekt i print men färgändringen visas inte. Kalendern verkar också visa datum en dag efter verkligt datum. #difficult
// FIX: FÖRKLARING FRÅN CHATGPT: Datumvalslogiken använde direkt likhet (==) för att jämföra datum, vilket inte är tillförlitligt i Swift eftersom datumobjekt innehåller tidskomponenter ner till millisekunden. Apples implementation är inte intuitiv här.


import SwiftUI

// ---------- Huvudvy för kaeledern ----------
struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var showDateAlert = false
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                HeaderView(
                    title: "Kalenderoversikt",
                    subtitle: "Velg dato du ønsker å booke"
                )
                
                // Kalender Grid
                VStack(spacing: 15) {
                    MonthHeaderView(
                        currentMonth: viewModel.currentMonth,
                        formatMonth: viewModel.formatMonth,
                        moveMonth: viewModel.moveMonth
                    )
                    
                    DayHeaderView()
                    
                    CalendarGridView(viewModel: viewModel)
                }
            .navigationDestination(for: String.self) { destination in
                if destination == "BookingDestination" {
                    BookingView(startDate: $viewModel.startDate, endDate: $viewModel.endDate)
                }
            }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.customGrey, lineWidth: 1)
                )
                .padding(.horizontal)
                
                //Spacer()
                
                InfoView()
                
                // BookingView navigation implemented with NavigationLink and state
                NavigationLink(value: "BookingDestination") {
                    EmptyView()
                }
                
                // Book Hytte button with onTapGesture and alert
                ButtonView(text: "Book Hytte")
                    .onTapGesture {
                        if viewModel.startDate == nil || viewModel.endDate == nil ||
                            Calendar.current.isDate(viewModel.startDate ?? Date(), inSameDayAs: viewModel.endDate ?? Date()) {
                            showDateAlert = true
                        } else {
                            navigationPath.append("BookingDestination")
                        }
                    }
               
//                    .padding(.bottom, 20)
            }
            .task {
                print("Henter tilgjengelighet for:", Calendar.monthOnlyFormatter.string(from: viewModel.currentMonth))

                if viewModel.holidays.isEmpty {
                    await viewModel.loadHolidays()
                }
                let monthString = Calendar.monthOnlyFormatter.string(from: viewModel.currentMonth)
                viewModel.loadBackendUnavailableDates(forMonth: monthString, cabinId: 1)
            }
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
            .alert("Velg dato", isPresented: $showDateAlert) {
                Button("OK", role: .cancel) {
                    showDateAlert = false
                }
            } message: {
                Text("Du må velge minst én natt for å kunne booke hytten.")
            }
        }
    }
}
