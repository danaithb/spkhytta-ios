//
//  SplashScreenView.swift
//  hytte
//
//  Created by Jana Carlsson on 21/02/2025.
//

//
//  SplasView.swift
//  News App
//
//  Created by Anonym on 21/11/2024.
//
//with color red green yellow and blue
//techer has cart animation in cartView.





import SwiftUI

struct SplashScreenView: View {
    
    var onAnimationComplete: () -> Void
    var body: some View {
        ZStack {
            //set whole screen to black
            //set this back to just black. only one splash screen som this wont be needed. just to test and learn how to change colors.
            Color(.splashScreenBlue)
                .ignoresSafeArea()
            VStack {
               
                
                Text("Hytte-Portalen")
                                        .foregroundColor(.white)
                                        .font(.custom("Poppins-Italic", size: 40))
                }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0)
                    {
                        onAnimationComplete()
                    }
                }
        }
    }
}

#Preview {
    SplashScreenView{
        print("Animation Completed")
        }
}

