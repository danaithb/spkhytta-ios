//
// LoginView.swift
// booking
//
// Created by Mariana and Abigail on 21/02/2025.


import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack(spacing: 20) {
//            HStack {
//                Image("logo-darkmode")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 140)
//                    .padding(.leading, 16)
//                Spacer()
//            }
//            .padding(.top, 40)
            
            Spacer()
                .frame(height: 280) // ner med bilden
            
            Image("logo-lightmode")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
            
            Spacer()
                .frame(height: 5) // utrymmet efter bilden. mini nu.
            
            VStack(alignment: .leading, spacing: 8) {
                Text("E-postadresse")
                    .font(.subheadline)
                TextField("", text: $viewModel.email)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.black, lineWidth: 1.5)
                    )
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                
                Text("Passord")
                    .font(.subheadline)
                    .padding(.top, 8)
                SecureField("", text: $viewModel.password)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black, lineWidth: (1.5)))
            }
            .padding(.horizontal)
            
            if !viewModel.errorMessage.isEmpty {
                Text("Fyll inn riktig e-postadresse og passord")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Spacer()
                .frame(height: 10)
           
            Button(action: {
                viewModel.login()
                if viewModel.isAuthenticated {
                    isLoggedIn = true
                }
            }) {
                HStack {
                    Image(systemName: "lock")
                        .foregroundStyle(.white)
                    Text("Logg inn")
                }
                .frame(width: 300, height: 50)
                //.padding(.vertical, 0)
                .background(Color.customBlue)
                .foregroundColor(.white)
                .cornerRadius(6)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
        }
        .background(Color.white)
        .onChange(of: viewModel.isAuthenticated) {
            isLoggedIn = viewModel.isAuthenticated
        }
    }
}
