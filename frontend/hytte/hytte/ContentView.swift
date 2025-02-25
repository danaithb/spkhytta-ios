//  ContentView.swift
//  hytte
//
//  Created by Mariana and Abigail on 19/02/2025.

//--Darkmode klar--
//filtrerings settings i settings view på vilken sorts hytter man skulle vilja ha.

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var isActive = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if isFirstLaunch {
            SplashScreenView {
                withAnimation {
                    isActive = true
                    isFirstLaunch = false
                    // är användare auth i fb koll
                    isLoggedIn = authViewModel.isAuthenticated
                }
            }
        } else if !isLoggedIn {
            // bug error vill inte ha parameter.
            LoginView(viewModel: authViewModel, isLoggedIn: $isLoggedIn)
        } else {
            TabView {
                //Kalender
                NavigationStack {
                    CalendarView()
                }
                .tabItem {
                    Image(systemName: "calendar.circle")
                    Text("Kalender")
                }
                
                //min sida
                NavigationStack {
                    ProfileView()
                }
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Min Side")
                }
                
                //settings
                NavigationStack {
                    SettingsView(isDarkMode: $isDarkMode, isLoggedIn: $isLoggedIn, authViewModel: authViewModel)
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

#Preview {
    ContentView()
} // de här ska hänga ihop och visa splashview sen direkta till login.
