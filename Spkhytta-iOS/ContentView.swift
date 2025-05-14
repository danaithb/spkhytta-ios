//
//  ContentView.swift
//  hytte
//
//  Created by Mariana and Abigail on 19/02/2025.

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var isActive = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        if !isActive && !authViewModel.isAuthenticated {
            SplashScreenView {
                withAnimation {
                    isActive = true
                    isFirstLaunch = false
                    isLoggedIn = authViewModel.isAuthenticated
                }
            }
        } else if !isActive && authViewModel.isAuthenticated {
            // Om användaren allrede är autentiserad
            Color.clear
                .onAppear {
                    isActive = true
                    isFirstLaunch = false
                    isLoggedIn = true
                }

        } else if !isLoggedIn {
           LoginView(viewModel: authViewModel, isLoggedIn: $isLoggedIn)
        } else {
            TabView {
                
                // Hjem
                Tab("Hjem", systemImage: "house") {
                    NavigationStack {
                        HomeView()
                    }
                }
                
                //Kalender
                Tab("Kalender", systemImage: "calendar.circle") {
                    NavigationStack {
                        CalendarView()
                    }
                }
                
                
                //min sida
                Tab("Min Side", systemImage: "person.circle") {
                    NavigationStack {
                        ProfileView()
                    }
                }
                
                //settings
                Tab("Innstillninger", systemImage: "gear") {
                    NavigationStack {
                        SettingsView(
                            isDarkMode: $isDarkMode, isLoggedIn: $isLoggedIn, authViewModel: authViewModel
                        )
                    }
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
         }
    }
}

#Preview {
    ContentView()
}



