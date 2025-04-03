//  BookingView.swift
// Calendar
//
// Created by Jana Carlsson on 23/03/2025.
//

// TODO
// 1. lägg till så att det bara visas ett datum i mitten om personen bara bokar ett datum.
// 2. ska man ha med referens nummer här? får man inte det när man har bekräftat bokningen?
// 3. till Elin, ser det bättre ut om de datum som är nu ligger närmare om det bara ska visas ett datum? det ser nog väldigt rart ut om de ligger långt från sen blir det bara ett datum där pilen är nu. DONE
// 4. varför en avbryt knapp, den pilen tar dig tillbaka till kalendern och avbryter allt. FÅTT SVAR PÅ
// 5. vad ska vara i den tredje framen som är tom på prototype varsion 2? FÅTT SVAR OP
// 6. Kan menyn doppa upp. när den droppar ner så får den inte plats. FÅTT SVAR PÅ

//till gruppen,ska man kunna boka bara en dag, eller måste det vara en natt också? DONE

//lägg till error om man inte har tryckt på ett datum. DONE

import SwiftUI

// ---------- Bokningsvy ----------
struct BookingView: View {
    // BUG: Kan inte sätta startDate och endDate till nil eftersom de är let
    // FIX: Ändra till binding för att kunna kommunicera tillbaka till föregående vy
    //ändra mina let till binding för att kunna sätta start date och end date till nil. de ska ha kontakt med den andra skärmen. kan inte vara let.
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    @Environment(\.dismiss) private var dismiss
    @State private var numberOfPeople: String = "Antall"
    
    var body: some View {
        VStack {
            
            
            
            BookingContentView(
                title: "Kontaktinformasjon",
                contents: [
//
                HStack {
                   Text("Navn:")
                    .fontWeight(.bold)
                   Text("Ola Norman")
                },
                
                HStack {
                    Text("Mobil:")
                    .fontWeight(.bold)
                    Text("99999999")
                },
                HStack {
                    Text("E-postadresse:")
                    .fontWeight(.bold)
                    Text("ola.norman@spk.no")
                }
                ]
            )
            .padding(.top, 30)
            // ---------- Valda datum ----------
            if endDate != nil && startDate != nil {
                BookingContentView(
                    title: "Valgt dato",
                    subtitle: "Dine valgte datoer",
                    contents: [
                        HStack {
                            Spacer()
                            
                            if let start = startDate {
                                Text("\(start, formatter: Calendar.dateFormatter)")
                                    .padding(.trailing, 10)
                            }
                            Text("-")
                                .padding(.trailing, 10)
                            if let end = endDate {
                                Text("\(end, formatter: Calendar.dateFormatter)")
                            }
                            Spacer()
                        }
                    ]
                )
            }
            else if endDate == nil && startDate != nil {
                // BUG: Visas inte i mitten vid endast ett datum
                // FIX: Placera i mitten med frame alignment
                BookingContentView(
                    title: "Valgt dato",
                    subtitle: "Dine valgte datoer",
                    contents: [
                        HStack {
                if let start = startDate {
                    Text("\(start, formatter: Calendar.dateFormatter)")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                }
                     ]
                    )
            }
            
            // ---------- Antal personer ----------
            // BUG: Dropdown-menyn kanske inte får plats på mindre skärmar
            // FIX: Justera storlek eller använd annan lösning som ScrollView
            BookingContentView(
                title: "Antall personer",
                subtitle: "Hvor mange ønsker du ta med",
                contents: [
                    Menu {
                        ForEach(1...8, id: \.self) { number in
                            Button("\(number)") {
                                numberOfPeople = "\(number)"
                               
                            }
                        }
                    } label: {
                        HStack {
                            Text(numberOfPeople)
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    }
                        .frame(maxWidth: .infinity, alignment: .center)
                 ]
                )
                Spacer()
            
            // Bekräfta bokning knapp
                ButtonView(
                    text: "Bekreft Booking"
                )
                .onTapGesture {
                    if let start = startDate, let end = endDate {
                        print("Booking from \(start) to \(end)")
                        
                    } else if let start = startDate {
                        print("Booking for \(start)")
                        
                    } else {
                        print("No dates selected")
                        
                    }
                    print("number of people: \(numberOfPeople)")
                    // BUG: Kan inte nollställa datumen eftersom de är "let" inte "@Binding"
                    // FIX: Ändra till binding och avkommentera raden nedan
                    //ändared en if i calendarView .task. för att inte ladda två gånger. 
                    startDate = nil
                    endDate = nil
                    dismiss()
                }
            }
            
            .font(.subheadline)
            .padding(.bottom, 20)//bra höjd för att man ska kunna trycka med tummen på knappen.
        }
    
}

// Uncomment this when you have Calendar.dateFormatter defined elsewhere
// #Preview {
//     BookingView(startDate: Date(), endDate: Date().addingTimeInterval(86400 * 3))
// }
