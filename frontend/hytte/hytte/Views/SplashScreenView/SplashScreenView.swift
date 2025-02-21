//  Created by Mariana och Abigail on 21/02/2025.
// Här ska det bytas till Poppins-Bold text

import SwiftUI

struct SplashScreenView: View {
    var onAnimationComplete: () -> Void
    var body: some View {
        ZStack {
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

