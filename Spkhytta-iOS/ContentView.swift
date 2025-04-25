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
//--måste ämdra något här så att den visas även om användare är auth. splash sla visas oavsett.

          

// .badge("Här kan man lägga tex eller siffra") för att visa om det är någon uppdatering på sidan. Nil döljer badge. för att se om det är några nya uppdateringar så gör en @State variabel för unreadMessages som sen sätts till 0 när användaren loggar in på sin sida (detta kan bara göras med Tab).

  
import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @State private var isActive = false

    @StateObject private var viewModelWrapper = ViewModelWrapper()

    var body: some View {
        Group {
            if let authViewModel = viewModelWrapper.authViewModel {
                if !isActive && !authViewModel.isAuthenticated {
                    SplashScreenView {
                        withAnimation {
                            self.isActive = true
                            self.isFirstLaunch = false
                        }
                    }
                } else if !isActive && authViewModel.isAuthenticated {
                    Color.clear
                        .onAppear {
                            self.isActive = true
                            self.isFirstLaunch = false
                            self.isLoggedIn = true
                        }
                } else if !authViewModel.isAuthenticated || !isLoggedIn {
                    LoginView(viewModel: authViewModel, isLoggedIn: $isLoggedIn)
                        .onChange(of: authViewModel.isAuthenticated) { oldValue, newValue in
                            print("ContentView observer: authViewModel.isAuthenticated ändrades från \(oldValue) till \(newValue)")
                            if newValue {
                                self.isLoggedIn = true
                                print("ContentView: isLoggedIn satt till TRUE")
                            }
                        }
                } else {
                    TabView {
                        Tab("Hjem", systemImage: "house") {
                            NavigationStack {
                                HomeView()
                            }
                        }

                        Tab("Kalender", systemImage: "calendar.circle") {
                            NavigationStack {
                                CalendarView()
                                    .environmentObject(authViewModel) // ✅ viktig rad
                            }
                        }

                        Tab("Min Side", systemImage: "person.circle") {
                            NavigationStack {
                                ProfileView(authViewModel: authViewModel)
                                    .environmentObject(authViewModel)
                            }
                        }

                        Tab("Instillinger", systemImage: "gear") {
                            NavigationStack {
                                SettingsView(
                                    isDarkMode: $isDarkMode,
                                    isLoggedIn: $isLoggedIn,
                                    authViewModel: authViewModel
                                )
                                .environmentObject(authViewModel)
                            }
                        }
                    }
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                    .environmentObject(authViewModel)
                }
            } else {
                ProgressView("Laster inn...")
            }
        }
        .onAppear {
            if viewModelWrapper.authViewModel == nil {
                let storage = UserStorage(modelContext: modelContext)
                viewModelWrapper.authViewModel = AuthViewModel(userStorage: storage)
            }
        }
        .onChange(of: viewModelWrapper.authViewModel?.isAuthenticated) { oldValue, newValue in
            if let newValue = newValue, !newValue && isLoggedIn {
                isLoggedIn = false
            }
        }
    }
}

fileprivate class ViewModelWrapper: ObservableObject {
    @Published var authViewModel: AuthViewModel?
}

