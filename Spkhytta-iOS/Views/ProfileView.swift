//
//  ProfileView.swift
//  Spkhytta-iOS
//
//  Created by Mariana and Abigail on 24/02/2025....
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                VStack(spacing: 4) {
                    Text("Min Side")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 12)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.customGrey, lineWidth: 1)
                        .frame(width: 180, height: 180)

                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 100, height: 100)
                }

                if let user = viewModel.userInfo {
                    VStack(spacing: 4) {
                        Text(user.name)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text("Poeng: \(user.points)")
                            .font(.headline)
                            .padding(.top, 4)
                        
                        if let quarantineDate = viewModel.parsedQuarantineDate() {
                            Text("Karantene til: \(quarantineDate.formatted(.dateTime.day().month(.wide).year()))")
                                .font(.subheadline)
                                .foregroundColor(.customRedDays)
                        } else {
                            Text("Ingen karantene")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundColor(.gray)
                        }
                    }
                } else {
                    Text("Laster brukerinfo...")
                        .foregroundColor(.gray)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Mine bookinger")
                        .font(.title3)
                        .fontWeight(.semibold)

                    if viewModel.bookings.isEmpty {
                        Text("Ingen bookinger funnet.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.bookings) { booking in
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("**Hytte:** \(booking.cabinName)")
                                   
                                    Spacer()
                                    Text("**Pris:** \(Int(booking.price)) kr")
                                }

                                VStack(spacing: 8) {
                                    Text("**Dato:** \(booking.startDate) – \(booking.endDate)")
                                    Text("Status på booking:")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)

                                    HStack(spacing: 8) {
                                        Text(viewModel.localizedStatus(booking.status))
                                        Circle()
                                            .fill({
                                                switch booking.status.lowercased() {
                                                case "confirmed":
                                                    return Color.green
                                                case "cancelled":
                                                    return Color.red
                                                case "pending":
                                                    return Color.orange
                                                default:
                                                    return Color.gray
                                                }
                                            }())
                                            .frame(width: 14, height: 14)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray)
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}

#Preview {
    ProfileView()
}
