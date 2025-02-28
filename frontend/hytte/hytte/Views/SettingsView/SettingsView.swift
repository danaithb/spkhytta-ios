//SettingsView.swift
//Created by Mariana and Abigail on 24/02/2025
//filterings setting ska kunna visa vilken hytte man vill se i future versioner.
//darkomdelight mode--- klart
//NavStack iOS 16 minimu krav.

import SwiftUI

struct SettingsView: View {
    @Binding var isDarkMode: Bool
    @Binding var isLoggedIn: Bool
    var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("App Settings")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                //filtrerings settings här
                //logg ut.
                Section(header: Text("Konto")) {
                    Button("Logg ut") {
                        authViewModel.logout()
                        isLoggedIn = false
                    }
                    .foregroundColor(.red)
                }
            }
            //byt den här till version två. den ska vara vanlig navigationTitle enligt iOS standard. inte med inline som är sekundär överskrift.
            //The .inline option shows small titles, which are useful for secondary, tertiary, or subsequent views in your navigation stack.
            //https://www.hackingwithswift.com/articles/216/complete-guide-to-navigationview-in-swiftui
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Instillinger")
                        .font(.largeTitle.bold())
                        .accessibilityAddTraits(.isHeader)
                }
            }
        }
    }
}
