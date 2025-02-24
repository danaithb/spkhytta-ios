//
//  SettingsView.swift
//  hytte
//
//  Created by Mariana and Abigail on 24/02/2025.
//
//Darkmode lightmode
//Filtrerings settings i settings view på vilken sorts hytter man skulle vilja ha.


import SwiftUI

struct SettingsView: View {
    @Binding var isDarkMode: Bool
    var body: some View {
        VStack {
            Text("Settings")
            Toggle("Dark Mode", isOn: $isDarkMode)
        }
    }
}

#Preview {
    SettingsView(isDarkMode: .constant(false))
}
