//
//  APIRequest.swift
//  Closest10
//
//  Created by Ben Foard on 27/3/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case noData
}

struct RestaurantResponse: Decodable {
    let restaurants: [Restaurant]
}

class APIRequest {
    static let shared = APIRequest()
    
    func fetchRestaurants(for postcode: String, completion: @escaping (Result<[Restaurant], Error>) -> Void) {
        let endpoint = "https://uk.api.just-eat.io/discovery/uk/restaurants/enriched/bypostcode/\(postcode)"
        guard let url = URL(string: endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        

        URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                print("API Error")
                completion(.failure(error))
                return
            }

            guard let data = data else {
                print("No data from API")
                completion(.failure(APIError.noData))
                return
            }
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let preview = jsonString.prefix(100000)
                    print("JSON Preview:\n\(preview)...")
                }

                let decoder = JSONDecoder()
                let restaurantResponse = try decoder.decode(RestaurantResponse.self, from: data)
                completion(.success(restaurantResponse.restaurants))
            } catch {
                print("Error decoding JSON")
                completion(.failure(error))
            }
        }.resume()
    }
}
