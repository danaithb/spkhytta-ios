//
//  ProfileView.swift
//  hytte
//
//  Created by Mariana and Abigail on 24/02/2025.
//

import SwiftUI


struct ProfileView: View {
    var body: some View {
        ScrollView{
            VStack{
                // Profil Side
                Text("Min Side")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top)
                
                VStack{
                    //Profil Bilder og Navn
                    Image(systemName:"person.circle")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .padding()
                }
                
                VStack  {
                    Text("Ola Nordaman")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Text("It-Utvikler")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
                
                VStack{
                    Text("Mine Booking")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding()
                    
                    
                }
                        
                HStack{
                    Text("Dato: 01.01.205")
                    Spacer()
                    Text("Anatall personer: 4")
                }
                .padding()
                
                VStack{
                    HStack{
                        Text("Status på Booking")
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .padding()
                    
                    HStack{
                        Text("Bekreftet")
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                    } 
                    
                }
            }
        }
                    
    }
}









#Preview {
    ProfileView()
}
