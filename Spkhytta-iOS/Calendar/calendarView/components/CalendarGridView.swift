//  CalendarGridView.swift
//  Calendar
//
//  Created by Jana Carlsson on 18/03/2025.
//
// BUG: Problem med dagens datum som blev otillgängligt fast det inte var bokat.
// Jämförelserna med unavailableDates fungerade inte som tänkt eftersom
// tidszoner ställer till det, ibland är 14:e mars den 13:e på kvällen.
//
// FIX: Normaliserar alla datum vid jämförelse och använder contains(normalizedDate)
// istället för Calendar.current.isDate som jag testade först, som också krånglade
// #drivesMeCraaaaazy varför måste datum vara så krångliga??

// TODO
// 1. Optimera calendar grid drawing för bättre prestanda
// 2. Lägg till stöd för att markera bokade datum som är egna bokningar
// 3. Förbättra visuell indikering för helgdagar
// 4. Lägga till animation vid val av datumintervall
// 5. Refaktorera till separat vy för varje kalendercell
// 6. Implementera caching för förbättrad prestanda när man byter månad



// ---------- Kalender Grid Vy ----------
import SwiftUI
import SwiftData

struct CalendarGridView: View {
    // BUG: Tidigare behövde funktionalitet flyttas från CalendarView till en egen View
    // FIX: Flyttade logiken till ViewModel och använder bara ObservedObject här
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
            ForEach(viewModel.getCalendarDays()) { dateWrapper in
                if let date = dateWrapper.date {
                    let day = viewModel.calendar.component(.day, from: date)
                    let isHoliday = viewModel.isHoliday(date: date)
                    let isTodaysDate = viewModel.calendar.isDate(date, inSameDayAs: Date())
                    let isPastDate = date < viewModel.normalizeDate(Date()) && !isTodaysDate
                    let isBooked = viewModel.unavailableDates.contains(viewModel.normalizeDate(date))
                    let isUnavailable = isBooked || isPastDate
                    let isInRange = viewModel.isDateInRange(date: date)
                    
                    ZStack {
                        // Bakgrundscirkel för datum
                        Circle()
                            .fill(CalendarGridHelpers.backgroundColor(
                                isHoliday: isHoliday,
                                isUnavailable: isUnavailable,
                                isSelected: isInRange,
                                isTodaysDate: isTodaysDate
                            ))
                            .frame(width: 36, height: 36)
                        
                        // Blå cirkel runt dagens datum
                        if isTodaysDate {
                            Circle()
                                .stroke(Color.blue.opacity(0.8), lineWidth: 2)
                                .frame(width: 36, height: 36)
                        }
                        
                        // Datumtext med dynamisk färgsättning
                        Text("\(day)")
                            .font(.system(size: 16))
                            .fontWeight(.medium)
                            .foregroundColor(CalendarGridHelpers.textColor(
                                isHoliday: isHoliday,
                                isUnavailable: isUnavailable,
                                isTodaysDate: isTodaysDate,
                                isSelected: isInRange
                            ))
                    }
                    .onTapGesture {
                        if !isUnavailable {
                            viewModel.handleDateSelection(date: date)
                        }
                    }
                    .disabled(isUnavailable)
                } else {
                    // Tomma celler för kalendergrid
                    Text("")
                        .frame(width: 36, height: 36)
                }
            }
        }
        .padding(.horizontal, 6)
    }
}
