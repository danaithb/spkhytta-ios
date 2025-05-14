// BookingContentView.swift
// Calendar
//Created by Mariana och Abigail  on 27/03/2025.
//

import Foundation
import SwiftUI

//wraper struct
struct BookingContentView: View {
    let title: String
    let subtitle: String?
    let content: AnyView
    
    // initialsiering med undertittel å enkel Text som innehåll
    // bra för enkle texter som status etc når man vill slippa skapa egen text-thing
    init(title: String, subtitle: String? = nil, content: String) {
        self.title = title
        self.subtitle = subtitle
        self.content = AnyView(Text(content))
    }
    
    // initialsiering med undertittel og valfri view
    // virker med alla types av visuella kompoents, enkelt med bilder osv
    init(title: String, subtitle: String? = nil, content: some View) {
        self.title = title
        self.subtitle = subtitle
        self.content = AnyView(content)
    }
    
    // initialsiering med undertittel och flere views som array
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
            // huvud-tittel centrerad øverst
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
            
            // vallgfri undertitel, visas bara om den finns
            // bruker optional chaning för att slippa massa if-satser i anropet
            if let subtitle = subtitle {
                Text(subtitle)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            content
        }
       .padding()
       .background(
           RoundedRectangle(cornerRadius: 12)
            .stroke(Color.customGrey, lineWidth: 1)
       )
       .padding(.horizontal)
       .padding(.bottom, 10)
    }
}
