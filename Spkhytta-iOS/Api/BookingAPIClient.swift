////
////  BookingAPIClient.swift
////  BookingApp
////
////  Created by Mariana och Abigail on 09/04/2025.
////TODO kolla om antal personer finns med i databasen.
////ta bort id. det genereras från backend.
////för postman test "https://8add7b00-6637-4dd8-8388-5a6548334f69.mock.pstmn.io/api/bookings"

import Foundation
import Firebase
import FirebaseAuth

class BookingAPIClient {
    static let shared = BookingAPIClient()
    
    private init() {}
    
    // Uppdaterad URL till vår lokala test server
    private let baseURL = "http://127.0.0.1:5000/api/bookings"
    
    // Struktur för att hålla bokningsdata
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
            print("Invalid dates: start date must be before or equal to end date")
            completion(.failure(.invalidDates))
            return
        }
        
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user found")
            completion(.failure(.authenticationError))
            return
        }
        
        print("Firebase UID: \(currentUser.uid)")
        
        currentUser.getIDToken { token, error in
            if let error = error {
                print("Failed to retrieve token: \(error.localizedDescription)")
                completion(.failure(.authenticationError))
                return
            }
            
            guard let token = token else {
                print("Token is nil")
                completion(.failure(.authenticationError))
                return
            }
            
            print("Firebase token received")

            let dateFormatter = ISO8601DateFormatter()
            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate)
            
            let bookingData = BookingRequest(
                cabinId: 1,
                startDate: startDateString,
                endDate: endDateString,
                numberOfPeople: numberOfPeople
            )
            
            guard let jsonData = try? JSONEncoder().encode(bookingData) else {
                print("Failed to encode booking data to JSON")
                completion(.failure(.unknownError))
                return
            }
            
            guard let url = URL(string: self.baseURL) else {
                print("Invalid URL: \(self.baseURL)")
                completion(.failure(.unknownError))
                return
            }
            
            print("Sending booking request to backend: \(self.baseURL)")
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network error during booking request: \(error.localizedDescription)")
                    completion(.failure(.networkError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Unexpected response format")
                    completion(.failure(.unknownError))
                    return
                }
                
                print("Response status code: \(httpResponse.statusCode)")
                
                switch httpResponse.statusCode {
                case 200...299:
                    if let data = data,
                       let responseText = String(data: data, encoding: .utf8) {
                        print("Booking response: \(responseText)")
                        completion(.success(responseText))
                    } else {
                        let reference = "SPK-\(Int.random(in: 10000...99999))"
                        print("No response body. Generated booking reference: \(reference)")
                        completion(.success(reference))
                    }
                default:
                    print("Server returned error code: \(httpResponse.statusCode)")
                    completion(.failure(.serverError(httpResponse.statusCode)))
                }
            }.resume()
        }
    }
    
    // För lokal testning utan backend
    func mockBookingRequest(
        startDate: Date,
        endDate: Date,
        completion: @escaping (Result<String, BookingError>) -> Void
    ) {
        print("Simulating booking request without backend")
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
            let referenceNumber = "SPK-\(Int.random(in: 10000...99999))"
            print("Generated mock booking reference: \(referenceNumber)")
            completion(.success(referenceNumber))
        }
    }
}
