//
//  CalendarButton.swift
//  Calendar
//
//  Created by Mariana och Abigail on 17/03/2025.
//

// TODO
// 1. Hantera alert-meddelande om inget datum är valt
// 2. Lägga till onTapGesture och action-hantering igen
// 3. Integrera med start och slutdatum



// ---------- Knapp för bokning ----------
import SwiftUI

struct ButtonView: View {
    var text: String
    // BUG: Knappen har ingen koppling till datumvalen eller action-hantering
    // FIX: Återinföra startDate, endDate, action och alertAction parametrar
   
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.customBlue)
            )
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
    }
}

//#Preview {
//    ButtonView()
//}
