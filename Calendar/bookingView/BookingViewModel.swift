////
////  BookingViewModel.swift
////  Calendar
////
////  Created by Jana Carlsson on 23/03/2025.
////
//
//import SwiftUI
//
//import SwiftUI
//
//struct BookingViewModel: View {
//    
//    
//    var body: some View {
//        ZStack {
//            Color(UIColor.systemGray5)
//                .edgesIgnoringSafeArea(.all)
//            
//            VStack(spacing: 0) {
//                Text("Bekreft booking")
//                    .font(.title2)
//                    .padding(.top, 20)
//                    .padding(.bottom, 10)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.horizontal, 20)
//                
//                HStack {
//                    ZStack {
//                        Circle()
//                            .stroke(Color.black, lineWidth: 2)
//                            .frame(width: 36, height: 36)
//                        
//                        Image(systemName: "arrow.left")
//                            .foregroundColor(.black)
//                    }
//                    
//                    Text("Book hytte")
//                        .font(.headline)
//                        .padding(.leading, 10)
//                    
//                    Spacer()
//                }
//                .padding(.horizontal, 20)
//                .padding(.vertical, 10)
//                
//                ScrollView {
//                    VStack(spacing: 15) {
//                        //
//                        
//                        // Valgt dato card
//                        
//                        
//                       
//                        // Empty card
//                        VStack {
//                            // Empty as in the original
//                        }
//                        .frame(height: 100)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.white)
//                        .cornerRadius(8)
//                        .shadow(color: Color.black.opacity(0.05), radius: 2)
//                        .padding(.horizontal)
//                        
//                        // Buttons
//                        VStack(spacing: 10) {
//                            Button(action: {
//                                // Confirm booking action
//                            }) {
//                                Text("Bekreft booking")
//                                    .fontWeight(.medium)
//                                    .foregroundColor(.white)
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(Color.blue)
//                                    .cornerRadius(5)
//                            }
//                            .padding(.horizontal)
//                            
//                            Button(action: {
//                                // Cancel action
//                            }) {
//                                Text("Avbryt")
//                                    .fontWeight(.medium)
//                                    .foregroundColor(.black)
//                                    .frame(maxWidth: .infinity)
//                                    .padding()
//                                    .background(Color.white)
//                                    .cornerRadius(5)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 5)
//                                            .stroke(Color.blue, lineWidth: 1)
//                                    )
//                            }
//                            .padding(.horizontal)
//                        }
//                        .padding(.top, 20)
//                        .padding(.bottom, 30)
//                    }
//                }
//            }
//            .background(Color.white)
//            .cornerRadius(0)
//            .frame(maxWidth: 420)
//        }
//    }
//}
//
//struct BookingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingViewModel()
//    }
//}
