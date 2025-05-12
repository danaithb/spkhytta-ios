//
//  HeaderView.swift
//  Calendar
//
//  Created by Mariana och Abigail on 17/03/2025.


import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String?
    
    init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // Titel
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            // Undertext (optional)
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.black) // kansje ha secondary som färg här?
                    .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        // Med subtitle
        HeaderView(
            title: "Kalenderoversikt",
            subtitle: "Velg dato du ønsker å booke"
        )
        
        // Utan subtitle
        HeaderView(title: "Endast titel")
        
        // Annan exempel
        HeaderView(
            title: "Min Kalender",
            subtitle: "Håll koll på dina bokningar"
        )
    }
    .padding()
}
