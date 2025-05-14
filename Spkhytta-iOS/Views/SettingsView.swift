//
//SettingsView.swift
//Created by Mariana and Abigail on 24/02/2025
//NavStack iOS 16 minimu krav.

import SwiftUI

struct SettingsView: View {
    @Binding var isDarkMode: Bool
    @Binding var isLoggedIn: Bool
    var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 0) {
            Text("Innstillinger")
                .font(.system(size: 28, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 16)
                .padding(.bottom, 20)

            List {
                Section(header:
                    Text("App-innstillinger")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                ) {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                }

                Section(header: Text("Konto")) {
                    Button("Logg ut") {
                        authViewModel.logout()
                        isLoggedIn = false
                    }
                    .foregroundColor(.red)
                }
            }
            .listStyle(.insetGrouped)
        }
        .background(Color(.systemGroupedBackground))
    }
}
