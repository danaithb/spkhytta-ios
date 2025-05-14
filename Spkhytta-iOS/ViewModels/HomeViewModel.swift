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
    
    let images = ["hytteBilde", "hytteBilde2", "hytteBilde3", "hytteBilde4", "hytteBilde5"]
    
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
    
    // Priser og poäng
    let workDaysPrice = "0 kr"
    let workDaysPoints = "0 poeng"
    let regularDays = "500 kr"
    let regularDaysPoints = "3 poeng"
    
    //vise, skjule
    func toggleShowAll() {
        showAll.toggle()
    }
}
