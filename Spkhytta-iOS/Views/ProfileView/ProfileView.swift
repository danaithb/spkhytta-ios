////
////  ProfileView.swift
////  hytte
////
////  Created by Mariana and Abigail on 24/02/2025.
////
//
//import SwiftUI
//
//struct ProfileView: View {
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 16) {
//                // Prfile Side
//                Text("Min side")
//                    .font(.largeTitle)
//                    .bold()
//                    .padding(.top)
//
//                // Profil Bilder
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
//                        .frame(width: 180, height: 180)
//
//                    Image(systemName: "person.circle.fill")
//                        .resizable()
//                        .foregroundColor(.gray)
//                        .frame(width: 100, height: 100)
//                }
//
//                // Navn og  Jobb Title
//                VStack(spacing: 4) {
//                    Text("Ola Norman")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//
//                    Text("It-Utvikler")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//
//                // Booking Seksjon
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Mine bookinger")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//
//                    VStack(alignment: .leading, spacing: 16) {
//                        HStack {
//                            Text("**Dato:** 03–06-2025")
//                            Spacer()
//                            Text("**Antall personer:** 4")
//                        }
//
//                        VStack(spacing: 8) {
//                            Text("Status på booking:")
//                                .font(.subheadline)
//                                .fontWeight(.semibold)
//
//                            HStack(spacing: 8) {
//                                Text("Bekreftet")
//                                Circle()
//                                    .fill(Color.green)
//                                    .frame(width: 14, height: 14)
//                            }
//                        }
//                        .frame(maxWidth: .infinity, alignment: .center)
//                    }
//                    .padding()
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.gray.opacity(0.5))
//                    )
//                }
//                .padding(.horizontal)
//            }
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    ProfileView()
//}
//import SwiftUI
//import SwiftData
//
//struct ProfileView: View {
//    @ObservedObject var authViewModel: AuthViewModel
//    @Query private var users: [User]
//    
//    // Computed property to get current user
//    private var currentUser: User? {
//        users.first(where: { $0.userId == authViewModel.userId })
//    }
//    
//    init(authViewModel: AuthViewModel = AuthViewModel()) {
//        self.authViewModel = authViewModel
//        
//        // Create a default query for all users
//        let descriptor = FetchDescriptor<User>()
//        self._users = Query(descriptor)
//    }
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 16) {
//                // Profile Side
//                Text("Min side")
//                    .font(.largeTitle)
//                    .bold()
//                    .padding(.top)
//
//                // Profile Bilder
//                ZStack {
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
//                        .frame(width: 180, height: 180)
//
//                    Image(systemName: "person.circle.fill")
//                        .resizable()
//                        .foregroundColor(.gray)
//                        .frame(width: 100, height: 100)
//                }
//
//                // Name from SwiftData or AuthViewModel
//                VStack(spacing: 4) {
//                    Text(getUserDisplayName())
//                        .font(.title2)
//                        .fontWeight(.semibold)
//
//                    Text("It-Utvikler")
//                        .font(.subheadline)
//                        .foregroundColor(.gray)
//                }
//
//                // Booking Seksjon
//                VStack(alignment: .leading, spacing: 12) {
//                    Text("Mine bookinger")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//
//                    VStack(alignment: .leading, spacing: 16) {
//                        HStack {
//                            Text("**Dato:** 03–06-2025")
//                            Spacer()
//                            Text("**Antall personer:** 4")
//                        }
//
//                        VStack(spacing: 8) {
//                            Text("Status på booking:")
//                                .font(.subheadline)
//                                .fontWeight(.semibold)
//
//                            HStack(spacing: 8) {
//                                Text("Bekreftet")
//                                Circle()
//                                    .fill(Color.green)
//                                    .frame(width: 14, height: 14)
//                            }
//                        }
//                        .frame(maxWidth: .infinity, alignment: .center)
//                    }
//                    .padding()
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.gray.opacity(0.5))
//                    )
//                }
//                .padding(.horizontal)
//            }
//            .padding()
//        }
//    }
//    
//    // Get display name from SwiftData if available, otherwise from AuthViewModel
//    private func getUserDisplayName() -> String {
//        if let user = currentUser {
//            return user.displayName
//        } else {
//            // Fallback to format from AuthViewModel
//            let email = authViewModel.userName
//            if !email.isEmpty, let username = email.split(separator: "@").first {
//                return String(username)
//                    .replacingOccurrences(of: ".", with: " ")
//            }
//            return "Användare"
//        }
//    }
//}
//
//#Preview {
//    ProfileView()
//}
//
//  ProfileView.swift
//  hytte
//
//  Created by Mariana and Abigail on 24/02/2025.
//

//
//  ProfileView.swift
//  hytte
//
//  Created by Mariana and Abigail on 24/02/2025.
//

//
//  ProfileView.swift
//  hytte
//
//  Created by Mariana and Abigail on 24/02/2025.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel
    @State private var currentUser: User?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Profil Side
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

                // Namn och Jobb Title
                VStack(spacing: 4) {
                    Text(currentUser?.displayName ?? getUserDisplayName())
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("It-Utvikler")
                        .font(.subheadline)
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
        .task {
            // Använd task för att köra asynkron kod
            currentUser = authViewModel.userStorage.getUser(by: authViewModel.userId)
        }
    }
    
    // Backup funktion om SwiftData inte har data
    private func getUserDisplayName() -> String {
        let email = authViewModel.userName
        if !email.isEmpty, let username = email.split(separator: "@").first {
            return String(username)
                .replacingOccurrences(of: ".", with: " ")
        }
        return "Användare"
    }
}

#Preview {
    ProfileView(authViewModel: AuthViewModel())
}
