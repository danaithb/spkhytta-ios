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
            Color.blue.opacity(0.8)
                .ignoresSafeArea()
            HStack(spacing: 0) {
               Text("HYTTE")
                    .foregroundColor(.white)
                    .font(.custom("Poppins-Regular", size: 40))
                Text("PORTALEN")
                     .foregroundColor(.white)
                     .font(.custom("Poppins-SemiBold", size: 40))
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

//#Preview {
//    SplashScreenView{
//        //print("Animation Completed")
//        }
//}

