//
//  HomeView.swift
//  Spkhytta-iOS
//
//  Created by Mariana og Abigail  on 08/04/2025.
//


// Deler de opp så at i sitt respektiv mappe for å gjøre koden litt mer ryddig........

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Utforsk tittel
                VStack(spacing: 4) {
                    Text("Utforsk")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 24)
                }

//                Text("Utforsk")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .padding(.top)
                // Utan subtitle
//                HeaderView(title: "Utforsk")
                
                // Bilder Carousel
                TabView {
                    ForEach(0..<viewModel.images.count, id: \.self) { index in
                        Image(viewModel.images[index])
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(10)
                            .padding(.horizontal, 25)
                    }
                }
                .padding(.horizontal, 15)
                .frame(height: 225)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                

                // Regler for Privat og Jobb tur
                VStack(alignment: .center, spacing: 10) {
                    VStack(spacing: 10) {
                        Text("Informasjon om priser og karantene")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Privat tur")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.center)
                        
                        Text("Per natt: 500kr, 3 poeng, karantene i 60 dager")
                            .font(.callout)
                            .multilineTextAlignment(.center)
                        
                        Text("Jobb tur")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.top, 6)
                            .multilineTextAlignment(.center)
                        
                        Text("Per natt: 0 kroner og 0 poeng, ingen karantene")
                            .font(.callout)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemBackground))
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.customGrey, lineWidth: 1)
                    )
                    .padding(.horizontal)
                }

                // Hytta tilbyr seksjon
                VStack(alignment: .leading, spacing: 16) {
                    Text("Hytta tilbyr")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Visar bara de första faciliteterna om showAll är false
                    if !viewModel.showAll {
                        // Visa bara 4 faciliteter (2 rader med 2 faciliteter)
                        HStack {
                            VStack(alignment: .leading, spacing: 20) {
                                facilitetView(icon: "wifi", text: "WiFi")
                                facilitetView(icon: "flame.fill", text: "Peis")
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 20) {
                                facilitetView(icon: "tv", text: "TV")
                                facilitetView(icon: "car.fill", text: "Gratis\nparkering")
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        // Visa alla 8 faciliteter när showAll är true
                        HStack {
                            VStack(alignment: .leading, spacing: 20) {
                                facilitetView(icon: "wifi", text: "WiFi")
                                facilitetView(icon: "flame.fill", text: "Peis")
                                facilitetView(icon: "doc.text.image", text: "Vaskema-\nskin")
                                facilitetView(icon: "drop.fill", text: "Ved vannet")
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 20) {
                                facilitetView(icon: "tv", text: "TV")
                                facilitetView(icon: "car.fill", text: "Gratis\nparkering")
                                facilitetView(icon: "figure.skating", text: "Skøyter")
                                facilitetView(icon: "fork.knife", text: "Kjøkken")
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.customGrey, lineWidth: 1)
                )
                .padding(.horizontal)
                
                // Använd ButtonView för knappen
                ButtonView(text: viewModel.showAll ? "Vis færre fasiliteter" : "Se alle fasiliteter")
                    .onTapGesture {
                        withAnimation {
                            viewModel.toggleShowAll()
                        }
                    }
                    .padding(.bottom, 30)
                
            }
        }
    }
    
    func facilitetView(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .frame(width: 24, height: 24)
            Text(text)
                .font(.body)
        }
    }
}

#Preview {
    HomeView()
}
