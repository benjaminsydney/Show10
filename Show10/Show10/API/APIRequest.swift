//
//  APIRequest.swift
//  Show10
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
    
    func fetchRestaurants(for postcode: String) async throws -> [Restaurant] {
        guard let url = URL(string: "https://uk.api.just-eat.io/discovery/uk/restaurants/enriched/bypostcode/\(postcode)") else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        /*
        if let jsonString = String(data: data, encoding: .utf8) {
            let preview = jsonString.prefix(100000)
            print("JSON Preview:\n\(preview)...")
        }
        */

        do {
            let decoder = JSONDecoder()
            let restaurantResponse = try decoder.decode(RestaurantResponse.self, from: data)
            return restaurantResponse.restaurants
        } catch {
            print("Error decoding JSON: \(error)")
            throw error
        }
    }
}
