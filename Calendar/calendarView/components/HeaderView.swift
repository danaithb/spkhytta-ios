//
//  HeaderView.swift
//  Calendar
//
//  Created by Jana Carlsson on 17/03/2025.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        // Titel
        Text("Kalenderoversikt")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top, 30)

        // Undertext
        Text("Velg dato du ønsker å booke")
            .font(.subheadline)
            .foregroundColor(.black) //kansek ha secondary som färg här?
            .padding(.bottom, 10)

    }
}

#Preview {
    HeaderView()
}
