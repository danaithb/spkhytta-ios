//
//  CalendarGridView.swift
//  Calendar
//
//  Created by Mariana och Abigail on 18/03/2025.


// ---------- Kalender Grid Vy ----------
import SwiftUI
import SwiftData

struct CalendarGridView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
            ForEach(viewModel.getCalendarDays()) { dateWrapper in
                if let date = dateWrapper.date {
                    let day = viewModel.calendar.component(.day, from: date)
                    let isHoliday = viewModel.isHoliday(date: date)
                    let isTodaysDate = viewModel.calendar.isDate(date, inSameDayAs: Date())
                    let isPastDate = date < viewModel.normalizeDate(Date()) && !isTodaysDate
                    let isBooked = viewModel.backendUnavailableDates.contains(viewModel.normalizeDate(date))
                    let isUnavailable = isBooked || isPastDate
                    let isInRange = viewModel.isDateInRange(date: date)
                    
                    ZStack {
                        Circle()
                            .fill(CalendarGridHelpers.backgroundColor(
                                isHoliday: isHoliday,
                                isUnavailable: isUnavailable,
                                isSelected: isInRange,
                                isTodaysDate: isTodaysDate
                            ))
                            .frame(width: 36, height: 36)
                        
                        
                        if isTodaysDate {
                            Circle()
                                .stroke(Color.customBlue, lineWidth: 2)
                                .frame(width: 36, height: 36)
                        }
                        
                        // Datotext
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
