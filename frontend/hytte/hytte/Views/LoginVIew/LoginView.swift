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
    @ObservedObject private var viewModel = AuthViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Image("spk-logo-dark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140)
                    .padding(.leading, 16)
                Spacer()
            }
            .padding(.top, 40)
            
            Spacer()
                .frame(height: 80) // ner med bilden
            
            Image("logo-lightmode")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            
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
                HStack {
//                    Image(systemName: "lock")
//                        .foregroundColor(.gray)
//                        .padding(.leading, 10)
                    SecureField("", text: $viewModel.password)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 10)
                        .background(RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.black, lineWidth: (1.5)))
                }
            }
            .padding(.horizontal)
            
            if !viewModel.errorMessage.isEmpty {
                Text("Fyll inn e-postadresse og passord")
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Spacer()
                .frame(height: 10)
           
                Button(action: viewModel.login) {
                        HStack {
                            Image(systemName: "lock")
                                .foregroundStyle(.white)
                            Text("Logg inn")
                        }
                       
                            .frame(width: 150, height: 50)
                        //.padding(.vertical, 0)
                            .background(Color.buttons_blue)
                            .foregroundColor(.white)
                            .cornerRadius(6)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Spacer()
                }
        .background(Color.white)
        .navigationDestination(isPresented: $viewModel.isAuthenticated) {
            //CalendarView() //kommentera ut den när vi vill directa till en sida. här blir det min sida eller kalendern? Den ska till kalendetn
        }
    }
}

#Preview {
    LoginView()
}

