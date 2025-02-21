//
//  SplashScreenView.swift
//  hytte
//
//  Created by Mariana and Abigail on 21/02/2025.
//Fråga Elin om hon vill ha en annan font på denna. 

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    var body: some View {
        if isActive {
            LoginView()//skicka till den sida du vill ha den till. vi har login view.
        } else {
           
                ZStack {
                    Color.splashScreen_blue
                        .ignoresSafeArea()
                    
                    Text("Hytte-Portalen")
                        .foregroundColor(.white)
                        .font(.system(size: 36, weight:.bold))
                
            }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.isActive = true
                    }
                }
                .fullScreenCover(isPresented: $isActive) {LoginView()}
           
        }
    }
       
}

#Preview {
    SplashScreenView()
}
