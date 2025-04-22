//
//  ProfileView.swift
// hytte
//
// Created by Mariana and Abigail on 24/02/2025.

import SwiftUI
import SwiftData
import FirebaseAuth
import Firebase

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var currentUser: User?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Min side")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        .frame(width: 180, height: 180)

                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.gray)
                        .frame(width: 100, height: 100)
                }

                VStack(spacing: 4) {
                    // Display user name
                    Text(authViewModel.user?.name ?? getUserDisplayName())
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("It-Utvikler")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

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
            if let user = Auth.auth().currentUser {
                print("ProfileView appeared, Firebase UID: \(user.uid)")
                user.getIDToken { token, error in
                    if let token = token {
                        print("FULL FIREBASE TOKEN IN PROFILE: \(token)")
                    }
                }
            }
            print("ProfileView appeared, authViewModel.user: \(String(describing: authViewModel.user))")
            currentUser = authViewModel.user
        }
    }

    private func getUserDisplayName() -> String {
        let email = authViewModel.user?.email ?? ""
        if !email.isEmpty, let username = email.split(separator: "@").first {
            return String(username).replacingOccurrences(of: ".", with: " ")
        }
        return "Användare"
    }
}
