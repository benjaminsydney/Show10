//
//  Show10Tests.swift
//  Show10Tests
//
//  Created by Ben Foard on 26/3/25.
//

import Testing
import XCTest
import SwiftUI

@testable import Show10


struct Show10Tests {
    
    // MARK: API
    // Check that valid postcode gets results from API
    @Test func validPostcodeReturnsRestaurants() async throws {
        let api = APIRequest.shared
        let validPostcodes = ["EC4M 7RF", "W1A 0AX", "M1 1AE", "B33 8TH", "CT17 9DS"]
        
        for postcode in validPostcodes {
            let fetchedRestaurants = try await api.fetchRestaurants(for: postcode)
            #expect(fetchedRestaurants.count != 0, "API returened no restaurants for \(postcode)")
        }
    }
    
    // MARK: PostcodeSearchBar
    // Check that postcode can be entered
    @Test func postcodeCanBeEntered() throws {
        var postcode = ""

        // Create a reusable, writable binding to the variable
        let postcodeBinding = Binding<String>(
            get: { postcode },
            set: { postcode = $0 }
        )
        
        let view = PostcodeSearchBar(
            postcode: postcodeBinding,
            isLoading: .constant(false),
            showPostcodeError: .constant(false),
            isSearchMode: true,
            onSearch: {}
        )
        
        postcodeBinding.wrappedValue = "RG23 8BH"
        
        #expect(view.postcode == "RG23 8BH", "Postcode is \(view.postcode), expected RG23 8BH")
    }
    
    // MARK: ResultsView
    // Make fake data and test if ResultsView shows 10 results
    @Test func resultsViewHasTenResults() throws {
        let mockData = getFakeData(inOrder: false)
        var postcode = "RG23 8BH"
        var hasSearched = true
        var isValid = true
        var showError = false
        var isLoading = false

        let view = ResultsView(
            postcode: .init(get: { postcode }, set: { postcode = $0 }),
            hasSearched: .init(get: { hasSearched }, set: { hasSearched = $0 }),
            isValidPostcode: .init(get: { isValid }, set: { isValid = $0 }),
            showPostcodeError: .init(get: { showError }, set: { showError = $0 }),
            isLoading: .init(get: { isLoading }, set: { isLoading = $0 }),
            rankedRestaurants: .init(get: { mockData }, set: { _ in }),
            onSearch: {},
            namespace: Namespace().wrappedValue
        )

        #expect(view.rankedRestaurants.count == 10, "Expected 10 restaurants in ResultsView")
    }
    
    // Make fake data and test that ResultsView displays the placement properly
    @Test func resultsInOrder() throws {
        let mockData = getFakeData(inOrder: true)

        var postcode = "RG23 8BH"
        var hasSearched = true
        var isValid = true
        var showError = false
        var isLoading = false

        let view = ResultsView(
            postcode: .init(get: { postcode }, set: { postcode = $0 }),
            hasSearched: .init(get: { hasSearched }, set: { hasSearched = $0 }),
            isValidPostcode: .init(get: { isValid }, set: { isValid = $0 }),
            showPostcodeError: .init(get: { showError }, set: { showError = $0 }),
            isLoading: .init(get: { isLoading }, set: { isLoading = $0 }),
            rankedRestaurants: .init(get: { mockData }, set: { _ in }),
            onSearch: {},
            namespace: Namespace().wrappedValue
        )

        let placements = view.rankedRestaurants.map(\.placement)

        #expect(placements == Array(1...10))
    }
    
    // Make fake data and test that ResultsView displays restauarant properly (matches fake data)
    @Test func restauarantDisplayedProperly() throws {
        let mockData = getFakeData(inOrder: true)

        var postcode = "RG23 8BH"
        var hasSearched = true
        var isValid = true
        var showError = false
        var isLoading = false

        let view = ResultsView(
            postcode: .init(get: { postcode }, set: { postcode = $0 }),
            hasSearched: .init(get: { hasSearched }, set: { hasSearched = $0 }),
            isValidPostcode: .init(get: { isValid }, set: { isValid = $0 }),
            showPostcodeError: .init(get: { showError }, set: { showError = $0 }),
            isLoading: .init(get: { isLoading }, set: { isLoading = $0 }),
            rankedRestaurants: .init(get: { mockData }, set: { _ in }),
            onSearch: {},
            namespace: Namespace().wrappedValue
        )

        let restaurant = view.rankedRestaurants[0]

        #expect(restaurant.restaurant.name == "Ben's Place 1")
        #expect(restaurant.restaurant.address == "1 Ben St, Brighton, RG23 8BH")
        #expect(restaurant.restaurant.cuisines == ["Free Food"])
        #expect(restaurant.restaurant.starRating == 5)
    }
    
    // MARK: Postcode validation
    // Tests that a postcode is valid in the expected UK format
    @Test func validPostcodeIsValid() throws {
        let validPostcodes = ["EC4M 7RF", "W1A 0AX", "M1 1AE", "B33 8TH", "SW1A 1AA"]
        for postcode in validPostcodes {
            #expect(isValidUKPostcode(postcode) == true, "Expected \(postcode) to be valid")
        }
    }
    
    // Tests if an entered string correctly registers as incorrect
    @Test func invalidPostcodeIsInvalid() throws {
        let invalidPostcodes = ["12345", "XYZ", "", "A1", " ", "RG2 3!:"]
        for postcode in invalidPostcodes {
            #expect(isValidUKPostcode(postcode) == false, "Expected \(postcode) to be invalid")
        }
    }
    
    // Make fake data for tests
    // inOrder: Bool -> true if the RankedRestaurant placement array should be in-order
    func getFakeData(inOrder: Bool) -> [RankedRestaurant] {
        let json = """
        [
            \(Array(1...10).map {
                """
                {
                    "id": "\($0)",
                    "name": "Ben's Place \($0)",
                    "address": {
                        "city": "Brighton",
                        "firstLine": "1 Ben St",
                        "postalCode": "RG23 8BH",
                        "location": {
                            "type": "Point",
                            "coordinates": [29.9766, 31.1354]
                        }
                    },
                    "rating": {
                        "starRating": 5
                    },
                    "driveDistanceMeters": 1,
                    "logoUrl": "https://encrypted-tbn0.gstatic.com/licensed-image?q=tbn:ANd9GcQz0aYBgJbJ_n313pNA8NudkDUuELQsikQtrJFHaC5fyRVbbYCyJ_-uSrPI20eytGih6GJ_YyjeXeWqTgZnbnw_9tj0rr2wiw",
                    "cuisines": [
                        { "name": "Free Food", "uniqueName": "freefood" }
                    ]
                }
                """
            }.joined(separator: ","))
        ]
        """

        let data = Data(json.utf8)
        do {
            let decoder = JSONDecoder()
            let restaurants = try decoder.decode([Restaurant].self, from: data)
            return restaurants.enumerated().map { index, restaurant in
                if inOrder {
                    RankedRestaurant(restaurant: restaurant, placement: index + 1)
                } else {
                    RankedRestaurant(restaurant: restaurant, placement: 10 - index)
                }
            }
        } catch {
            fatalError("Failed to decode fake restaurant data: \(error)")
        }
    }
    
}
