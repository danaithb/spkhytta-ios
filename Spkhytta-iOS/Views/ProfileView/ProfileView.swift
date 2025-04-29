//
//  ProfileView.swift
//  hytte
//
//  Created by Mariana and Abigail on 24/02/2025....
//

import SwiftUI

struct ProfileView: View {
    @State private var userInfo: UserInfo?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Prfile Side
                Text("Min side")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                // Profil Bilder
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        .frame(width: 180, height: 180)

                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 100, height: 100)
                }

                // Navn, epost og poeng (dynamisk)
                if let user = userInfo {
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
                    }
                } else {
                    Text("Laster brukerinfo...")
                        .foregroundColor(.gray)
                }

                // Booking Seksjon
                VStack(alignment: .leading, spacing: 12) {
                    Text("Mine bookinger")
                        .font(.title3)
                        .fontWeight(.semibold)

                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("**Dato:** 03–06-2025")
                            Spacer()
                            Text("**Antall personer:** 4")
                        }

                        VStack(spacing: 8) {
                            Text("Status på booking:")
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            HStack(spacing: 8) {
                                Text("Bekreftet")
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 14, height: 14)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5))
                    )
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .onAppear {
            UserAPIClient.shared.fetchUserInfo { info in
                DispatchQueue.main.async {
                    self.userInfo = info
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
