//
//  BookingConfirmationSheet.swift
//  Spkhytta-iOS
//
//  Created by Mariana and Abigail on 10/05/2025.


import SwiftUI

struct BookingConfirmationSheet: View {
    let bookingReference: String
    let onDone: () -> Void  //istendenfor duissmiss

    var body: some View {
        VStack(spacing: 0) {
            Text("Kvittering")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 30)
                .padding(.bottom, 30)

            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.customGrey, lineWidth: 1)
                    .frame(height: UIScreen.main.bounds.height * 0.4)
                    .overlay(
                        VStack(spacing: 20) {
                            Text("Takk!")
                                .font(.title3)
                                .fontWeight(.bold)
                                .padding(.top, 40)

                            Text("Se \"Mine side\" for status på booking.")
                                .font(.body)
                                .padding(.horizontal, 20)
                                .multilineTextAlignment(.center)

                            Text("Vipps til xxx.xx.xxx")
                                .font(.body)
                                .fontWeight(.medium)

                            Text("Takk for at du valgte å booke med Hytteportalen!")
                                .font(.body)
                                .padding(.horizontal, 20)
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 40)
                        }
                    )
            }
            .padding(.horizontal, 16)

            Spacer()

            Button(action: {
                onDone()  //callback til BookingView, hjelp fra Danial på SPK.
            }) {
                Text("Ferdig")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 30)
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
