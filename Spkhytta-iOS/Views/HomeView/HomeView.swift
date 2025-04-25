//
//  HomeView.swift
//  Spkhytta-iOS
//
//  Created by Mariana og Abigail  on 08/04/2025.
//


// Deler de opp så at i sitt respektiv mappe for å gjøre koden litt mer ryddig

import SwiftUI

struct Fasilitet: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
}

struct HomeView: View {
    @State private var showAll = false

    let images = ["bilder11", "bilder2", "bilder3", "bilder4", "bilder5", "bilder6",
                  "bilder7", "bilder8", "bilder9", "bilder10", "bilder1", "bilder12",
                  "bilder13", "bilder14"]

    let allFasiliteter: [Fasilitet] = [
        Fasilitet(icon: "car.fill", title: "Utsikt mot fjell"),
        Fasilitet(icon: "waveform.path.ecg", title: "Utsikt mot elv"),
        Fasilitet(icon: "drop", title: "Ved vannet"),
        Fasilitet(icon: "fork.knife", title: "Kjøkken"),
        Fasilitet(icon: "car.fill", title: "Gratis parkering"),
        Fasilitet(icon: "wifi", title: "WiFi tilgjengelig"),
        Fasilitet(icon: "tv", title: "TV"),
        Fasilitet(icon: "flame.fill", title: "Peis"),
        Fasilitet(icon: "snow", title: "Aircondition"),
        Fasilitet(icon: "leaf", title: "Nær natur"),
        Fasilitet(icon: "bicycle", title: "Sykkelutleie"),
        Fasilitet(icon: "figure.walk", title: "Turløyper"),
        Fasilitet(icon: "bed.double", title: "Komfortable senger"),
        Fasilitet(icon: "washer", title: "Vaskemaskin"),
        Fasilitet(icon: "lock.fill", title: "Sikker inngang"),
        Fasilitet(icon: "cup.and.saucer", title: "Kaffemaskin")
    ]

    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                
                // 👇 Image Carousel (updated style)
                TabView {
                    ForEach(images, id: \.self) { image in
                        Image(image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .frame(height: 250)
                            .background(Color.black.opacity(0.05))
                            .cornerRadius(16)
                            .padding(.horizontal)
                    }
                }
                .frame(height: 250)
                .tabViewStyle(PageTabViewStyle())

                // 👇 Payment Info Box
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "creditcard.fill")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.black)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Informasjon om priser og betalingsmåter")
                        Text("Røde-dager: 1000kr")
                        Text("Vanlig-dager: 100kr")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.3)))
                .frame(maxWidth: .infinity, alignment: .leading)

                // 👇 Fasiliteter Section (clean layout)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Hva dette stedet tilbyr")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                        ForEach(showAll ? allFasiliteter : Array(allFasiliteter.prefix(6))) { fasilitet in
                            HStack(alignment: .center, spacing: 10) {
                                Image(systemName: fasilitet.icon)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.primary)

                                Text(fasilitet.title)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.9)
                            }
                        }
                    }

                    // 👇 See more / less button
                    Button(action: {
                        withAnimation {
                            showAll.toggle()
                        }
                    }) {
                        Text(showAll ? "Vis færre fasiliteter" : "Se alle fasiliteter")
                            .font(.body)
                            .foregroundColor(Color.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

//#Preview {
//    HomeView()
//}

