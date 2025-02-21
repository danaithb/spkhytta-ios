//
//  ContentView.swift
//  hytte
//
//  Created by Mariana and Abigail on 19/02/2025.
//

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
        
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
    }
}

#Preview {
    ContentView()
}
