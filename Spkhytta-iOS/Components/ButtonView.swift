//
//  CalendarButton.swift
//  Calendar
//
//  Created by Mariana och Abigail on 17/03/2025.
//
// ---------- Knapp för bokning ----------
import SwiftUI

struct ButtonView: View {
    var text: String
   
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
