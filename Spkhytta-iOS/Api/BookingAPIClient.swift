//
//  BookingAPIClient.swift
//  BookingApp
//
//  Created by Mariana och Abigail on 09/04/2025.

import Foundation
import Firebase
import FirebaseAuth

class BookingAPIClient {
    static let shared = BookingAPIClient()
    
    private init() {}
    
//    //TA BORT SEN
//    private let baseURL = "http://127.0.0.1:5000/api/bookings"
    
    // URL för API anrop - Ändra till riktiga backend URL:n senare
    private let baseURL = "https://hytteportalen-307333592311.europe-west1.run.app/api/bookings"
    
    enum BookingError: Error {
        case invalidDates
        case authenticationError
        case networkError(Error)
        case serverError(String)
        case unknownError
    }
    
    // Skicka bokningsinformation till backend med auth token
    // - Parameters
    //   - startDate: Bokningens startdatum
    //   - endDate: Bokningens slutdatum
    //   - numberOfPeople: Antall personer som skal være med i bookingen
    //   - completion: Completion handler med Result
    func sendBookingRequest(
        cabinId: Int,
        startDate: Date,
        endDate: Date,
        numberOfPeople: Int = 1,
        bookingPurpose: String? = nil, //Bookingsyfte
        completion: @escaping (Result<String, BookingError>) -> Void
    ) {
        // Kolla om datumen är giltiga
        guard startDate <= endDate else {
            completion(.failure(.invalidDates))
            return
        }
        
        // Kolla om användaren är inloggad
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(.authenticationError))
            return
        }
        
        // Hämta ID token
        currentUser.getIDToken { token, error in
            if let error = error {
                print("Kunde inte hämta token: \(error.localizedDescription)")
                completion(.failure(.authenticationError))
                return
            }
            
            guard let token = token else {
                completion(.failure(.authenticationError))
                return
            }
            
            // Formatera datumen för API req (yyyy-MM-dd)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate)
            
            // Skapa bokningsdata
            let bookingData = BookingRequest(
                cabinId: cabinId,
                startDate: startDateString,
                endDate: endDateString,
                numberOfGuests: numberOfPeople,
                businessTrip: bookingPurpose == "Jobb" //må manuelt velge her, for nå LAGT TILL =="Jobb"
            )

            // Debug-print booking JSON før du sender den
            if let json = try? JSONEncoder().encode(bookingData),
               let jsonString = String(data: json, encoding: .utf8) {
                print("[DEBUG] Booking JSON som sendes: \(jsonString)")
            }

            // Konvertera bokningsdata till JSON
            guard let jsonData = try? JSONEncoder().encode(bookingData) else {
                print("Kunne ikke encode bookingData.")
                completion(.failure(.unknownError))
                return
            }
            
            // Skapa URL request
            guard let url = URL(string: self.baseURL) else {
                print("Ugyldig URL.")
                completion(.failure(.unknownError))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            
            print("[BookingAPIClient] Sender booking til backend...")
            
            // Skicka requesten
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Nätverk error: \(error.localizedDescription)")
                    completion(.failure(.networkError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Ukjent feil: ingen HTTP-respons")
                    completion(.failure(.unknownError))
                    return
                }
                
                // Kolla respons statuskod
                switch httpResponse.statusCode {
                case 200...299:
                    if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                        print("[BookingAPIClient] Suksess! Respons: \(responseBody)")
                        completion(.success(responseBody))
                    } else {
                        print("[BookingAPIClient] Suksess, men ingen lesbar respons")
                        completion(.success("Booking registrert"))
                    }
                    
                default:
                    if let data = data, let backendMessage = String(data: data, encoding: .utf8) {
                        print("Feil fra backend: \(backendMessage)")
                        completion(.failure(.serverError(backendMessage)))
                    } else {
                        completion(.failure(.serverError("Ukjent serverfeil")))
                    }
                }
                
                func fetchAvailabilityForMonth(month: String, cabinId: Int, token: String, completion: @escaping ([DayAvailability]) -> Void) {
                    guard let url = URL(string: "https://hytteportalen-307333592311.europe-west1.run.app/api/calendar/availability") else {
                        print("Ugyldig URL for kalender")
                        return
                    }

                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

                    let body: [String: Any] = [
                        "month": month,         // eks: "2025-05"
                        "cabinId": cabinId      // eks: 1
                    ]

                    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

                    URLSession.shared.dataTask(with: request) { data, response, error in
                        guard let data = data else {
                            print("Ingen data")
                            return
                        }
                        do {
                            let result = try JSONDecoder().decode([DayAvailability].self, from: data)
                            completion(result)
                        } catch {
                            print("Feil ved decoding: \(error)")
                        }
                    }.resume()
                }

            }.resume()
        }
    }
    
    // För testing utan en backend
    func mockBookingRequest(
        startDate: Date,
        endDate: Date,
        completion: @escaping (Result<String, BookingError>) -> Void
    ) {
        // Simulera nätverks fördröjning
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            // Generera en fake bokningsreferens
//            let referenceNumber = "SPK-\(Int.random(in: 10000...99999))"
//            completion(.success(referenceNumber))
        }
    }
}
