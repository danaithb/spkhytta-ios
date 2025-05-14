//
//  InfoView.swift
//  Calendar
//
//  Created by Mariana och Abigail on 17/03/2025.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Tilgjengelighet")
                .font(.subheadline)
                //.fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack(spacing: 30) {
                HStack {
                    Capsule()
                        .fill(Color.customGrey)
                        .frame(width: 25, height: 10)

                    Text("Ikke tilgjengelig")
                        .font(.subheadline)
                        .foregroundColor(Color.customGrey)
                 }

                // Helligdag
                HStack {
                    Capsule()
                        .fill(Color.redDays)
                        .frame(width: 25, height: 10)

                    Text("Helligdag")
                        .font(.subheadline)
                        .foregroundColor(.redDays)//röd eller svart text?
                }
            }
        }
        .padding(.top, 20)
    }
}

#Preview {
    InfoView()
}
