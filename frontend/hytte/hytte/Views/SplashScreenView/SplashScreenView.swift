//
//  SplashScreenView.swift
//  hytte
//
//  Created Mariana and Abigail on 21/02/2025.
//


import SwiftUI

struct SplashScreenView: View {
    var animationDuration: () -> Void
    
    var body: some View {
        ZStack {
            Color.splashScreen_blue
                .ignoresSafeArea()
            VStack {
               Text("Hytte-Portalen")
                    .foregroundColor(.white)
                    .font(.system(.largeTitle))
                }
            .onAppear {
                //print("Spalsh visas")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
                    {
                        //print("timer har kört")
                        animationDuration()
                    }
            }
        }
    }
}

#Preview {
    SplashScreenView{
        //print("Animation Completed")
        }
}

