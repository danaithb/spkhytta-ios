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
            Color.customBlue
                .ignoresSafeArea()
            HStack(spacing: 0) {
               Text("HYTTE")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                Text("PORTALEN")
                     .foregroundColor(.white)
                     .font(.largeTitle)
                     .fontWeight(.bold)
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

