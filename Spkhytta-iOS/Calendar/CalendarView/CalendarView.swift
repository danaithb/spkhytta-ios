//
//CalendarView.swift
//Created by Mariana og Abigail on 28/02/2025
 

import SwiftUI

// ---------- Huvudvy för kaeleder ----------
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
                
                NavigationLink(value: "BookingDestination") {
                    EmptyView()
                }
                
                // Book Hytte button
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
                Text("Du må velge minst en natt for å kunne booke hytten.")
            }
        }
    }
}
