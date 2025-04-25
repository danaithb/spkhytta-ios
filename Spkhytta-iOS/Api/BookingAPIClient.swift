//
//  BookingAPIClient.swift
// BookingApp
//
//  Created by Mariana och Abigail on 09/04/2025.
//TODO kolla om antal personer finns med i databasen.
//ta bort id. det genereras från backend.
//för postman test "https://8add7b00-6637-4dd8-8388-5a6548334f69.mock.pstmn.io/api/bookings"

import Foundation
import Firebase
import FirebaseAuth

class BookingAPIClient {
    static let shared = BookingAPIClient()
    
    private init() {}
    
    private let baseURL = "http://127.0.0.1:5000/api/bookings"
    
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

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDateString = dateFormatter.string(from: startDate)
            let endDateString = dateFormatter.string(from: endDate)
            
            let bookingData: [String: Any] = [
                "cabinId": 1,
                "startDate": startDateString,
                "endDate": endDateString
            ]
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: bookingData) else {
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
                    if let data = data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                               let id = json["id"] as? Int {
                                // Använd ID direkt från servern utan att formatera om det
                                print("Booking response with ID: \(id)")
                                // Backend bör returnera hela referensnumret i sitt svar
                                // Tills backend uppdateras, använder vi ID:t som är
                                completion(.success(String(id)))
                            } else if let responseText = String(data: data, encoding: .utf8) {
                                print("Booking response: \(responseText)")
                                completion(.success(responseText))
                            } else {
                                print("Kunde inte tolka bokningssvar")
                                completion(.failure(.unknownError))
                            }
                        } catch {
                            if let responseText = String(data: data, encoding: .utf8) {
                                print("Booking raw response: \(responseText)")
                                completion(.success(responseText))
                            } else {
                                print("Kunde inte läsa svar från server")
                                completion(.failure(.unknownError))
                            }
                        }
                    } else {
                        print("No response body")
                        completion(.failure(.unknownError))
                    }
                default:
                    print("Server returned error code: \(httpResponse.statusCode)")
                    completion(.failure(.serverError(httpResponse.statusCode)))
                }
            }.resume()
        }
    }
    
    func fetchUserBookings(completion: @escaping (Result<[BookingInfo], BookingError>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            print("Ingen autentiserad användare hittades")
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
                print("Token är nil")
                completion(.failure(.authenticationError))
                return
            }
            
            guard let url = URL(string: "http://127.0.0.1:5000/api/bookings/user") else {
                print("Ogiltig URL för användarbokningar")
                completion(.failure(.unknownError))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Nätverksfel vid hämtning av bokningar: \(error.localizedDescription)")
                    completion(.failure(.networkError(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Oväntat svarsformat")
                    completion(.failure(.unknownError))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    if let data = data {
                        do {
                            let bookings = try JSONDecoder().decode([BookingInfo].self, from: data)
                            completion(.success(bookings))
                        } catch {
                            print("Fel vid avkodning av bokningar: \(error)")
                            completion(.failure(.unknownError))
                        }
                    } else {
                        completion(.success([]))
                    }
                case 401, 403:
                    print("Användaren saknar behörighet att se bokningar: \(httpResponse.statusCode)")
                    completion(.failure(.authenticationError))
                default:
                    print("Servern returnerade felkod: \(httpResponse.statusCode)")
                    completion(.failure(.serverError(httpResponse.statusCode)))
                }
            }.resume()
        }
    }
}

struct BookingInfo: Codable {
    let id: Int
    let userId: Int
    let cabinId: Int
    let startDate: String
    let endDate: String
    let status: String
    let queuePosition: Int
    let price: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "userId"
        case cabinId = "cabinId"
        case startDate = "startDate"
        case endDate = "endDate"
        case status
        case queuePosition = "queuePosition"
        case price
    }
}
