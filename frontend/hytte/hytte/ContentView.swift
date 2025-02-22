//
//  ContentView.swift
//  hytte
//
//  Created by Mariana and Abigail on 19/02/2025.
//user details will be saved in fb. not in the database. if we want the auth in database we will need to put encryption by our selves. need extra code for encryption. 

import SwiftUI

struct ContentView: View {
    @State var isActive = UserDefaults.standard.bool(forKey: "isActive")
    var body: some View {
        if isActive {
            LoginView()//skicka till den sida du vill ha den till. vi har login view.
        } else {
            SplashScreenView {
                UserDefaults.standard.set(true, forKey: "isActive")
                isActive = true
            }
        }
    }

}

#Preview {
    ContentView()
}
