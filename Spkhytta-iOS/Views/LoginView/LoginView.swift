// LoginView.swift
// booking
//
// Created by Mariana and Abigail on 21/02/2025.
//bytt låsen till button ikke texfield.
//man ska kunna fortsätta att vara inloggad med sin brukare även om man stänger ner appen. inte "" varje gång.

// LoginView.swift
// booking
//
// Created by Mariana and Abigail on 21/02/2025.
//bytt låsen till button ikke texfield.
//man ska kunna fortsätta att vara inloggad med sin brukare även om man stänger ner appen. inte "" varje gång.

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Binding var isLoggedIn: Bool
    @State private var isLoggingIn = false
    
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
                SecureField("", text: $viewModel.password)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black, lineWidth: (1.5)))
            }
            .padding(.horizontal)
            
            if !viewModel.errorMessage.isEmpty {
                Text(viewModel.errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Spacer()
                .frame(height: 10)
           
            Button(action: {
                print("Login knapp tryckt")
                isLoggingIn = true
                viewModel.login()
                // Inloggning hanteras asynkront i viewModel.login() via Task {}
            }) {
                HStack {
                    if isLoggingIn && !viewModel.isAuthenticated {
                        ProgressView()
                            .tint(.white)
                            .padding(.trailing, 5)
                    } else {
                        Image(systemName: "lock")
                            .foregroundStyle(.white)
                    }
                    Text("Logg inn")
                }
                .frame(width: 300, height: 50)
                .background(Color.customBlue)
                .foregroundColor(.white)
                .cornerRadius(6)
            }
            .disabled(isLoggingIn && !viewModel.isAuthenticated)
            .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
        }
        .background(Color.white)
        .onChange(of: viewModel.isAuthenticated) { oldValue, newValue in
            print("LoginView - isAuthenticated ändrat: \(oldValue) -> \(newValue)")
            if newValue {
                isLoggedIn = true
                isLoggingIn = false
            } else if !newValue && isLoggingIn {
                // Om autentisering misslyckades
                isLoggingIn = false
            }
        }
    }
}
