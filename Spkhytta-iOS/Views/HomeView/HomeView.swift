//
//  HomeView.swift
//  Spkhytta-iOS
//
//  Created by Mariana og Abigail  on 08/04/2025.
//


// Deler de opp så at i sitt respektiv mappe for å gjøre koden litt mer ryddig........

import SwiftUI

struct Fasilitet: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
}

struct HomeView: View {
    @State private var showAll = false

    let images = ["hytteBilde", "hytteBilde2", "hytteBilde", "hytteBilde4", "hytteBilde5", "hytteBilde6",
                  "hytteBilde7", "hytteBilde8", "hytteBilde9", "hytteBilde10"]

    let allFasiliteter: [Fasilitet] = [
        Fasilitet(icon:  "wifi", title: "WiFi tilgjengelig"),
        Fasilitet(icon: "tv", title: "TV"),
        Fasilitet(icon: "flame.fill", title: "Peis"),
        Fasilitet(icon: "car.fill", title: "Gratis parkering"),
        Fasilitet(icon: "washer", title: "Vaskemaskin"),
        Fasilitet(icon: "figure.ice.skating", title: "Skøyter"),
        Fasilitet(icon: "drop", title: "Ved vannet"),
        Fasilitet(icon: "fork.knife", title: "Kjøkken"),
        Fasilitet(icon: "snow", title: "Aircondition"),
        Fasilitet(icon: "leaf", title: "Nær natur"),
        Fasilitet(icon: "bicycle", title: "Sykkelutleie"),
        Fasilitet(icon: "figure.walk", title: "Turløyper"),
        Fasilitet(icon: "bed.double", title: "Komfortable senger"),
        Fasilitet(icon: "lock.fill", title: "Sikker inngang"),
        Fasilitet(icon: "cup.and.saucer", title: "Kaffemaskin")
    ]

    let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 32) {
                
                // Hjem Title
                HStack {
                    Text("Hjem")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.leading)
                    Spacer()
                }

                // Bilder Carousel (updated style)
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

                // Box til Informasjon om priser
                    VStack {
                                   HStack {
                                       VStack(alignment: .leading, spacing: 4) {
                                           Text("Informasjon om priser og Poeng")
                                               .fontWeight(.bold)
                                           Text("Røde-dager: 1000kr = 6 Poeng")
                                           Text("Vanlig-dager: 100kr = 4 Poeng")
                                               .font(.body)
                                               .foregroundColor(.black)
                                       }
                                       
                                   }
                                   .padding()
                                   .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3)))
                                   .frame(maxWidth: .infinity, alignment: .center) // Stretch the box to fill the width
                                   .padding(.horizontal) // Apply padding to center
                               }
                
                // Hytta tilbyr Seksjon
                VStack(alignment: .center, spacing: 22) {
                    Text("Hytta tilbyr")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
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

                    // Vis færre og alle knapp
                    Button(action: {
                        withAnimation {
                            showAll.toggle()
                        }
                    }) {
                        Text(showAll ? "Vis færre fasiliteter" : "Se alle fasiliteter")
                            .font(.body)
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.custom_blue)
                            .cornerRadius(12)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center) //  Sikre at alt er i midten
                
                // Legg til en spacer for å skyve innholdet opp eller ned etter behov
                Spacer()
            }
            .padding(.horizontal)
            .background(Color.gray.opacity(0.1)) // Sett en dempet bakgrunn
        }
    }
}

#Preview {
    HomeView()
}
