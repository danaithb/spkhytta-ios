//
//  InfoView.swift
//  Calendar
//
//  Created by Mariana och Abigail on 17/03/2025.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        // Tillgänglighet förklaring
        VStack(spacing: 20) {
            Text("Tilgjengelighet")
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)

            HStack(spacing: 30) {
                // Otillgänlig
                HStack {
                    Capsule()
                        .fill(Color.gray.opacity(0.8))
                        .frame(width: 25, height: 10)

                    Text("Ikke tilgjengelig")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .opacity(0.6)//helt svart om den röda ska svart?
                }

                // Helgdag
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

//#Preview {
//    InfoView()
//}
