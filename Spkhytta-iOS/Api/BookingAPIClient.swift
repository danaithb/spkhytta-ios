//
//  BookingAPIClient.swift
//  BookingApp
//
//  Created by Mariana och Abigail on 09/04/2025.
//TODO kolla om antal personer finns med i databasen.
//ta bort id. det genereras från backend.
//för postman test "https://8add7b00-6637-4dd8-8388-5a6548334f69.mock.pstmn.io/api/bookings"


//import Foundation
//import Firebase
//import FirebaseAuth
//
//class BookingAPIClient {
//    static let shared = BookingAPIClient()
//    
//    private init() {}
//    
//    // URL för API anrop - Ändra till riktiga backend URL:n senare
//    private let baseURL = "http://localhost:5000/api/bookings"
//    
//    // Struktur för att hålla bookingdata
//    struct BookingRequest: Codable {
//        let startDate: String
//        let endDate: String
//        //let userId: String
//        let numberOfPeople: Int
//    }
//    
//    enum BookingError: Error {
//        case invalidDates
//        case authenticationError
//        case networkError(Error)
//        case serverError(Int)
//        case unknownError
//    }
//    
//    // Skicka bokningsinformation till backend med auth token
//    //- Parameters ska vi ha med antal personer här. Finns det med i databsen? dubbelkolla det. ska läggas till.
//    //   - startDate: Bokningens startdatum
//    //   - endDate: Bokningens slutdatum
//    //  - completion: Completion handler med Result
//    func sendBookingRequest(
//        startDate: Date,
//        endDate: Date,
//        numberOfPeople: Int = 1,
//        completion: @escaping (Result<String, BookingError>) -> Void
//    ) {
//        // Kolla om datumen är giltiga
//        guard startDate <= endDate else {
//            completion(.failure(.invalidDates))
//            return
//        }
//        
//        // Kolla om användaren är inloggad
//        guard let currentUser = Auth.auth().currentUser else {
//            completion(.failure(.authenticationError))
//            return
//        }
//        
//        // Hämta ID token
//        currentUser.getIDToken { token, error in
//            if let error = error {
//                print("Kunde inte hämta token: \(error.localizedDescription)")
//                completion(.failure(.authenticationError))
//                return
//            }
//            
//            guard let token = token else {
//                completion(.failure(.authenticationError))
//                return
//            }
//            
//            // Formatera datumen för API req
//            let dateFormatter = ISO8601DateFormatter()
//            let startDateString = dateFormatter.string(from: startDate)
//            let endDateString = dateFormatter.string(from: endDate)
//            
//            // Skapa bokningsdata
//            let bookingData = BookingRequest(
//                startDate: startDateString,
//                endDate: endDateString,
//                //userId: currentUser.uid,
//                numberOfPeople: numberOfPeople
//            )
//            
//            // Konvertera bokningsdata till JSON
//            guard let jsonData = try? JSONEncoder().encode(bookingData) else {
//                completion(.failure(.unknownError))
//                return
//            }
//            
//            // Skapa URL request
//            guard let url = URL(string: "\(self.baseURL)") else {
//                completion(.failure(.unknownError))
//                return
//            }
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//            request.httpBody = jsonData
//            
//            // Skicka requesten
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    print("Nätverk error: \(error.localizedDescription)")
//                    completion(.failure(.networkError(error)))
//                    return
//                }
//                
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    completion(.failure(.unknownError))
//                    return
//                }
//                
//                // Kolla respons statuskod
//                switch httpResponse.statusCode {
//                case 200...299:
//                    // Lyckad respons
//                    if let data = data, let responseBody = String(data: data, encoding: .utf8) {
//                        completion(.success(responseBody))
//                    } else {
//                        // Generera ett fake boknings-ID för testing
//                        let referenceNumber = "SPK-\(Int.random(in: 10000...99999))"
//                        completion(.success(referenceNumber))
//                    }
//                    
//                default:
//                    // Hantera fel respons
//                    completion(.failure(.serverError(httpResponse.statusCode)))
//                }
//            }.resume()
//        }
//    }
//    
//    // För testing utan en backend
//    func mockBookingRequest(
//        startDate: Date,
//        endDate: Date,
//        completion: @escaping (Result<String, BookingError>) -> Void
//    ) {
//        // Simulera nätverks fördröjning
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
//            // Generera en fake bokningsreferens
//            let referenceNumber = "SPK-\(Int.random(in: 10000...99999))"
//            completion(.success(referenceNumber))
//        }
//    }
//}
import Foundation
import Firebase
import FirebaseAuth

class BookingAPIClient {
    static let shared = BookingAPIClient()
    
    private init() {}
    
    // URL för API anrop - Ändra till riktiga backend URL:n senare
    private let baseURL = "http://localhost:5000/api/bookings"
    
    // Struktur för att hålla bookingdata
    struct BookingRequest: Codable {
        let cabinId: Int
        let startDate: String
        let endDate: String
        let numberOfPeople: Int
    }
    
    enum BookingError: Error {
        case invalidDates
        case authenticationError
        case networkError(Error)
        case serverError(Int)
        case unknownError
    }
    
    // Skicka bokningsinformation till backend med auth token
    func sendBookingRequest(
        startDate: Date,
        endDate: Date,
        numberOfPeople: Int = 1,
        completion: @escaping (Result<String, BookingError>) -> Void
    ) {
        guard startDate <= endDate else {
            completion(.failure(.invalidDates))
            return
        }
        
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(.authenticationError))
            return
        }
        
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
            
            let dateFormatter = ISO8601DateFormatter()
            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate)
            
            let bookingData = BookingRequest(
                cabinId: 1, // Just nu bara en cabin
                startDate: startDateString,
                endDate: endDateString,
                numberOfPeople: numberOfPeople
            )
            
            guard let jsonData = try? JSONEncoder().encode(bookingData) else {
                completion(.failure(.unknownError))
                return
            }
            
            guard let url = URL(string: self.baseURL) else {
                completion(.failure(.unknownError))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Nätverk error: \(error.localizedDescription)")
                    completion(.failure(.networkError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.unknownError))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                        completion(.success(responseBody))
                    } else {
                        let referenceNumber = "SPK-\(Int.random(in: 10000...99999))"
                        completion(.success(referenceNumber))
                    }
                default:
                    completion(.failure(.serverError(httpResponse.statusCode)))
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
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let referenceNumber = "SPK-\(Int.random(in: 10000...99999))"
            completion(.success(referenceNumber))
        }
    }
}
