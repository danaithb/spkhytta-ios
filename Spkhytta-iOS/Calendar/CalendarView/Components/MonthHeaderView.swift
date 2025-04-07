//
//  MonthHeaderView.swift
//  Calendar
//
//  Created by Mariana och Abigail on 18/03/2025.
//

import SwiftUI


struct MonthHeaderView: View {
    let currentMonth: Date
    let formatMonth: (Date) -> String
    let moveMonth: (Int) -> Void
    
    var body: some View {
        HStack {
            Button(action: { moveMonth(-1) }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black)
            }

            Spacer()

            Text(formatMonth(currentMonth))
                .font(.title2)
                .fontWeight(.semibold)

            Spacer()

            Button(action: { moveMonth(1) }) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    MonthHeaderView()
//}
