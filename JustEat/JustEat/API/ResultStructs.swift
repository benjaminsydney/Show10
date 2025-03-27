//
//  ResultStructs.swift
//  Just Eat
//
//  Created by Ben Foard on 26/3/25.
//

import Foundation

struct Restaurant: Identifiable {
    let id: Int
    let name: String
    let cuisines: [String]
    let starRating: Double
    let address: Address
}

struct Address {
    let firstLine: String
    let postcode: String
    let coordinates: String
}
