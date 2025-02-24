//
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
    
    var body: some View {
        if isFirstLaunch {
            SplashScreenView(animationDuration: {
                withAnimation {
                    UserDefaults.standard.set(true, forKey: "isActive")
                    isFirstLaunch = false
                }
            })
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
                    SettingsView(isDarkMode: $isDarkMode)
                }
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setings")
                }
                .preferredColorScheme(isDarkMode ? .dark : .light)
            }
            .onAppear {
                isActive = false
                UserDefaults.standard.set(false, forKey: "isActive")
            }
        }
    }
}

#Preview {
    ContentView()
}
