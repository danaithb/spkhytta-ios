//
//  HomeViewModel.swift
//  Spkhytta-iOS
//
//  Created by Mariana and Abigail on 08/05/2025.

import SwiftUI

struct HyttaFasilitet {
    let icon: String
    let title: String
}

class HomeViewModel: ObservableObject {
    @Published var showAll = false
    
    // Bilderna som visas i karusellen
    let images = ["hytteBilde", "hytteBilde2", "hytteBilde3", "hytteBilde4", "hytteBilde5"]
    
    // Lista på faciliteter som ska visas
    let allFasiliteter = [
        HyttaFasilitet(icon: "wifi", title: "WiFi"),
        HyttaFasilitet(icon: "tv", title: "TV"),
        HyttaFasilitet(icon: "flame.fill", title: "Peis"),
        HyttaFasilitet(icon: "car.fill", title: "Gratis parkering"),
        HyttaFasilitet(icon: "washer", title: "Vaskemaskin"),
        HyttaFasilitet(icon: "figure.ice.skating", title: "Skøyter"),
        HyttaFasilitet(icon: "drop", title: "Ved vannet"),
        HyttaFasilitet(icon: "fork.knife", title: "Kjøkken")
    ]
    
    // Priser och poäng
    let rodeDagerPris = "1000kr"
    let rodeDagerPoeng = "3 poeng"
    let vanligDagerPris = "500kr"
    let vanligDagerPoeng = "3 poeng"
    
    // Funktion för att visa/dölja fler faciliteter
    func toggleShowAll() {
        showAll.toggle()
    }
}
