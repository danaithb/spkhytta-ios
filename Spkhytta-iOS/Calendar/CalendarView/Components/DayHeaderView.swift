//
//  DayHeaderView.swift
//  Calendar
//
//  Created by Mariana och Abigail on 18/03/2025.
//

import SwiftUI

struct DayHeaderView: View {
    //let dayNames: [String]
    var body: some View {
        HStack(spacing: 0) {
            ForEach(CalendarConstants.dayName, id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    DayHeaderView()
}
