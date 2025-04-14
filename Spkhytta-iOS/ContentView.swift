//  ContentView.swift
//  hytte
//
//  Created by Mariana and Abigail on 19/02/2025.

//--Darkmode klar--
//filtrerings settings i settings view på vilken sorts hytter man skulle vilja ha.

//Lagt till Tab eftersom .tabItem kommer bli deprecated. Fråga Danial vad man bör ha här. Tab måste vara Swift 5.9 eller senare. Om vi ska ha Tab: clean build projektet och radera derived data(tab ligger kommenterad).

//.symbolRenderingMode(.hierarchical) fungerar inte på tab, så symbolerna kommer att vara fyllda när de är i tab.

//TODO gör en signup sida så att backend kan få namn från frontend.
//darkmode i kalendern.
//lägg till bilder för login
//lägg till färger.
//log in button ska vara samma storlek som book hytte bytton, samma för home page button.
//byt färg på frame runt email and password på login sidan, TEST
//lägg till poppi fonts

//darkomode i kalendern: datum = vita, info grå sektionen syns inte alls ta bort opacity. gör den grå. cirkeln behöver ny färg för darkmode. subtitle. framcolor. dagensdatum.
//.background(Color(.systemBackground)) // Anpassas automatiskt till Light/Dark
//bookingview frames fropdown blir vit vit, så grå när man väljer datum.
//borde det inte vara samma färg på framen på alla sidor. ta upp med Elin om att prototypen har olika på login och resten.
//fixa calendar frameView, den kan vara utanför kalendern, då frame används på fera ställen i appen.

import SwiftUI
import SwiftData

struct ContentView: View {
    @State var isActive = false
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if !isActive && !authViewModel.isAuthenticated { //ordnade hierarki o mina loopar, nested var ingen bra ide. det blev rotigt.
            SplashScreenView {
                withAnimation {
                    isActive = true
                    isFirstLaunch = false
                    // är användare auth i fb koll
                    //--måste ämdra något här så att den visas även om användare är auth. splash sla visas oavsett.
                    isLoggedIn = authViewModel.isAuthenticated
                }
            }
        } else if !isActive && authViewModel.isAuthenticated {
            // Om användaren redan är autentiserad, hoppa över splash och sätt status direkt
            Color.clear
                .onAppear {
                    isActive = true
                    isFirstLaunch = false
                    isLoggedIn = true
                }
            
        } else if !isLoggedIn {
            // bug error vill inte ha parameter.--fixed
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
            //    .badge("Här kan man lägga tex eller siffra") för att visa om det är någon uppdatering på sidan. Nil döljer badge. för att se om det är några nya uppdateringar så gör en @State variabel för unreadMessages som sen sätts till 0 när användaren loggar in på sin sida (detta kan bara göras med Tab).
                
                //settings
               
                Tab("Setting", systemImage: "gear") {
                    NavigationStack {
                        SettingsView(
                            isDarkMode: $isDarkMode, isLoggedIn: $isLoggedIn, authViewModel: authViewModel
                            )
                        
                    }
                     
                }
                
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            //.padding()får kalendern att bli längre från kkanten. knappen blir mindre. 
        }
    }
}

#Preview {
    ContentView()
} // de här ska hänga ihop och visa splashview sen direkta till login.



