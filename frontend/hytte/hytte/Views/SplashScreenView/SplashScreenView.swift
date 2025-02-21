//
//  SplashScreenView.swift
//  hytte
//
//  Created by Mariana and Abigail on 21/02/2025.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack {
            ZStack {
                Color.splashScreen_blue
                    .ignoresSafeArea()
                
                Text("Hytte-Portalen")
                    .foregroundColor(.white)
                    .font(.system(size: 36, weight:.bold))
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
