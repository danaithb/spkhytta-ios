//
//  RadioButton.swift
//  Spkhytta-iOS
//
//  Created by Jana Carlsson on 06/05/2025.
//

import SwiftUI

struct RadioButton: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        HStack {
            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .foregroundColor(.blue)
                .font(.system(size: 20))
            Text(title)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white)
        .cornerRadius(10)
        
        .onTapGesture {
            onTap()
        }
    }
}

