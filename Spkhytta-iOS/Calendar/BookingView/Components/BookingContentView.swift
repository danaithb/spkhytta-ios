// BookingContentView.swift
// Calendar
//Created by Mariana och Abigail  on 27/03/2025.
//

import Foundation
import SwiftUI

// min wraper struct för att skapa en återanvändbar innehållsvy med olik titel o innehåll
struct BookingContentView: View {
    let title: String
    let subtitle: String?
    let content: AnyView
    
    
    
    // initialsiering med undertitel å enkel Text som innehåll
    // bra för enkla texter som status etc när man vill slippa skapa egen text-grej
    init(title: String, subtitle: String? = nil, content: String) {
        self.title = title
        self.subtitle = subtitle
        self.content = AnyView(Text(content))
    }
    
    // initialsiering med undertitel och valfri view
    // funkar med alla types av visuella kompoents, enkelt med bildr osv
    init(title: String, subtitle: String? = nil, content: some View) {
        self.title = title
        self.subtitle = subtitle
        self.content = AnyView(content)
    }
    
    // initialsiering med undertitel och flera views som array
    // smidig när man vill stapla flera grejjer under samma titel
    init(title: String, subtitle: String? = nil, contents: [some View]) {
        self.title = title
        self.subtitle = subtitle
        self.content = AnyView(
            VStack(spacing: 8) {
                ForEach(0..<contents.count, id: \.self) { index in
                    AnyView(contents[index])
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        )
    }
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // huvud-titeL centrerad överst
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // vallfri undertitel, visas bara om den finns
            // anvönder optional chaning för att slippa massa if-satser i anropet
            if let subtitle = subtitle {
                Text(subtitle)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            // huvud-innehållet här visas
            // använder AnyView för å ta vilken typ som helst, sllipper krångel
            content
                
        }
       .padding()
       .background(
           RoundedRectangle(cornerRadius: 12)
               .stroke(Color.gray.opacity(0.2), lineWidth: 1)
       )
       .padding(.horizontal)
       .padding(.bottom, 10) // xtra padding nere ger finare space mella views
    }
}


// Exempler på användning:
// 1. enkl text med undertitel
//            BookingContentView(
//                title: "Account Status",
//                subtitle: "Last updated today",
//                content: "Active"
//            )

// 2. en view med undertitel
//            BookingContentView(
//                title: "Favorite Icon",
//                subtitle: "Tap to change",
//                content: Image(systemName: "star.fill")
//                    .foregroundColor(.yellow)
//            )

// 3. Flera HStacks me undertitel - exmplet saknas helt typ
