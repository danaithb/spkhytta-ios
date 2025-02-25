//SettingsView.swift
//Created by Mariana and Abigail on 24/02/2025
//filterings setting ska kunna visa vilken hytte man vill se i future versioner.
//darkomdelight mode--- klart


import SwiftUI

struct SettingsView: View {
    @Binding var isDarkMode: Bool
    @Binding var isLoggedIn: Bool
    var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("App Settings")) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }
                
                //filtrerings settings här
                
                Section(header: Text("Konto")) {
                    Button("Logg ut") {
                        authViewModel.logout()
                        isLoggedIn = false
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Innstillinger")
        }
    }
}
