//
//CalendarView.swift

//Created by Mariana and Abigail on 28/02/2025
// TODO
// 1. lägg till så vi kan tryck på tex 5 som startdatum och 8 som slutdatum och alla får markeringar. Svep? eller hur gör du om du vill bara boka 5 och 8. Toggle (i inställnignar) om vi vill ha flera dager av eller på. Prata med grupppen om vilket alternaitv.
//// 2. gråmarkera daum som har passerat i kalendern. API --fixat
//// 3. läg till en blå cirkel runt dagens datum. --fixat
//// 4. lägg till onTapGesture där kommentarar säger i koden, default flera dager. kan huka av en och en på toggle i settings.
//// 5. (lägg till så att den vissar tre månder)--kansek--fixat--
//// 6. custom figur på helidaf ikke tilgenglig.--fixat med capsule--
//// 7. ta bort den röda cirkeln runt helgdager och ha ett rött nummer istället.-- fixat
//// 8. Ta bort så att du inte kan klicka eller booka passerade dager.--fixat
//// 9. Gråmarkera passerade dager.---fixat
//// 10. Book hytte knappen skicka till en ny boknings vy/sheet --fixat
//// 11. lägg till ljusera grå färg om dager har paserat.ser inte bra ut.
//// 12. gör nummret ljusera grå om datmet har passerat.gör inte
//// 13. inaktiv book hytte knappen om inga datum är valda? disabla knappen blir grå och ser inte bra ut, alert eller pop up iställt.
//// 14. klick en gång markera/två gånger avmarkera.--fixat
//// BUG: Problem med datumval - första gången jag trycker på dagens datum och avmarkerar det kan jag inte välja 31:a. Om jag går till en ny månad fungerar det igen. Dagens datum fungerar med 31:a, så det är bara första gången. Klicken registreras korrekt i print men färgändringen visas inte. Kalendern verkar också visa datum en dag efter verkligt datum. #difficult
//// FIX: FÖRKLARING FRÅN CHATGPT: Datumvalslogiken använde direkt likhet (==) för att jämföra datum, vilket inte är tillförlitligt i Swift eftersom datumobjekt innehåller tidskomponenter ner till millisekunden. Apples implementation är inte intuitiv här.
//// Till elin, secondary eller svart på dagarna i kalendern?
//
////kaelndern följer adminsidan färger på egna bokningar. grön för bekräftad, orange för pending? ide frpn produkteier. Version 2.
//
//add payment fine for now. but if we want more options add them to the bekreft boooking view.
//referensenummer should it be in the book hytte? we get ref number omce the cabin is booked from backend?.
//as soon as you log in you get userdata from backend.
//user details will be saved by swift data and avalible even if the internet connection is poor ot gone.
//same with my bookings. get from backend first, saved with swiftData.
//lägg till så att det registrerar hur många personer som man bokar för.
//Mer space mellan månad och framen




import SwiftUI
import SwiftData

// ---------- Huvudvy för kalendern ----------
struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var authViewModel: AuthViewModel // ✅ tillagd
    @StateObject private var viewModel = CalendarViewModel()
    @State private var showDateAlert = false
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                HeaderView()

                // Kalender Grid
                VStack(spacing: 15) {
                    MonthHeaderView(
                        currentMonth: viewModel.currentMonth,
                        formatMonth: viewModel.formatMonth,
                        moveMonth: viewModel.moveMonth
                    )
                    .padding(.bottom, 10)

                    DayHeaderView()

                    CalendarGridView(viewModel: viewModel)
                }
                .navigationDestination(for: String.self) { destination in
                    if destination == "BookingDestination" {
                        BookingView(
                            startDate: $viewModel.startDate,
                            endDate: $viewModel.endDate,
                            modelContext: modelContext
                        )
                        .environmentObject(authViewModel) // ✅ tillagd
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)

                InfoView()

                // BookingView navigation implemented with NavigationLink and state
                NavigationLink(value: "BookingDestination") {
                    EmptyView()
                }

                // Book Hytte button with onTapGesture and alert
                ButtonView(text: "Book hytte")
                    .onTapGesture {
                        if viewModel.startDate == nil {
                            showDateAlert = true
                        } else {
                            navigationPath.append("BookingDestination")
                        }
                    }
            }
            .task {
                if viewModel.holidays.isEmpty {
                    await viewModel.loadHolidays()
                }
            }
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
            .alert("Velg dato", isPresented: $showDateAlert) {
                Button("OK", role: .cancel) {
                    showDateAlert = false
                }
            } message: {
                Text("Du må velge minst én dato for å kunne booke hytten.")
            }
        }
    }
}
