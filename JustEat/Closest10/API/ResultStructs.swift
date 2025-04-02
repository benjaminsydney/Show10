//
//  ResultStructs.swift
//  Just Eat
//
//  Created by Ben Foard on 26/3/25.
//

import Foundation
import CoreLocation

struct RestaurantsResponse: Decodable {
    let metaData: MetaData
    let restaurants: [Restaurant]
}

struct MetaData: Decodable {
    let canonicalName: String
    let district: String
    let postalCode: String
    let area: String
    let location: Location
    let cuisineDetails: [CuisineDetail]
    let resultCount: Int
    let tagDetails: [TagDetail]
    let deliveryArea: String
}

struct Location: Decodable {
    let type: String
    let coordinates: [Double]
}

struct CuisineDetail: Decodable {
    let name: String
    let uniqueName: String
    let count: Int
}

struct TagDetail: Decodable {
    let displayName: String
    let key: String
    let priority: Int
}

struct Address: Decodable {
    let city: String
    let firstLine: String
    let postalCode: String
    let location: Location
}

struct Cuisine: Decodable {
    let name: String
    let uniqueName: String
}

struct RankedRestaurant: Identifiable {
    let restaurant: Restaurant
    let placement: Int
    
    var id: String { restaurant.id }
}

struct Restaurant: Decodable, Identifiable {
    let id: String
    let name: String
    let address: String
    let starRating: Double
    let driveDistanceMeters: Int
    let logoUrl: String
    let cuisines: [String]
    let coordinates: CLLocationCoordinate2D
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case address
        case rating
        case driveDistanceMeters
        case logoUrl
        case cuisines
    }
    
    private enum RatingKeys: String, CodingKey {
        case starRating
    }
    
    // Nested data
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        var fullAddress: Address!
        fullAddress = try container.decode(Address.self, forKey: .address)
        address = fullAddress.firstLine + ", " + fullAddress.city + ", " + fullAddress.postalCode
        driveDistanceMeters = try container.decode(Int.self, forKey: .driveDistanceMeters)
        logoUrl = try container.decode(String.self, forKey: .logoUrl)
        
        // (Star) Rating
        let ratingContainer = try container.nestedContainer(keyedBy: RatingKeys.self, forKey: .rating)
        starRating = try ratingContainer.decode(Double.self, forKey: .starRating)
        
        coordinates = CLLocationCoordinate2D(latitude: fullAddress.location.coordinates[1], longitude: fullAddress.location.coordinates[0])
        
        // Cuisine Name instead of [Cuisine]
        var cuisinesArray = [String]()
        var cuisinesContainer = try container.nestedUnkeyedContainer(forKey: .cuisines)
        while !cuisinesContainer.isAtEnd {
            let cuisine = try cuisinesContainer.decode(Cuisine.self)
            cuisinesArray.append(cuisine.name)
        }
        cuisines = cuisinesArray
    }
}
