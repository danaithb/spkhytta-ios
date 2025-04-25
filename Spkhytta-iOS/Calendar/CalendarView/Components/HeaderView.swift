//
//  HeaderView.swift
//  Calendar
//
//  Created by Mariana och Abigail on 17/03/2025.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        // Titel
        Text("Kalenderoversikt")
            .font(.title)
            .fontWeight(.bold)
            .padding(.top, 40)
            //.padding(.bottom, 15)

        // Undertext
        Text("Velg dato du ønsker å booke")
            .font(.subheadline)
            .foregroundColor(.black) //kansek ha secondary som färg här?
            .padding(.bottom, 10)

    }
}

//#Preview {
//    HeaderView()
//}
