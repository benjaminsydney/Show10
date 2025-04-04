//
//  FakeData.swift
//  Show10
//
//  Created by Ben Foard on 1/4/25.
//

import Foundation

struct FakeData {
    static let fakeRestaurants: [Restaurant] = {
        // Copy loads of data from the JSON response for testing
        let json = """
        [
            {
                "id": "147426",
                "name": "Sushi Place",
                "uniqueName": "sushi-place",
                "address": {
                    "city": "Brighton",
                    "firstLine": "123 Sushi Street",
                    "postalCode": "RG23 8BH",
                    "location": {
                        "type": "Point",
                        "coordinates": [-0.12345, 0.67890]
                    }
                },
                "rating": {
                    "count": 123,
                    "starRating": 4.5,
                    "userRating": 3
                },
                "isNew": false,
                "driveDistanceMeters": 500,
                "openingTimeLocal": "2025-04-01T10:00:00",
                "deliveryOpeningTimeLocal": "2025-04-01T10:00:00",
                "deliveryEtaMinutes": {"rangeLower": 15, "rangeUpper": 30},
                "isCollection": true,
                "isDelivery": true,
                "isOpenNowForCollection": true,
                "isOpenNowForDelivery": true,
                "isOpenNowForPreorder": false,
                "isTemporarilyOffline": false,
                "deliveryCost": 1.99,
                "minimumDeliveryValue": 10.0,
                "defaultDisplayRank": 1,
                "isTemporaryBoost": false,
                "isPremier": false,
                "logoUrl": "https://d30v2pzvrfyzpo.cloudfront.net/uk/images/restaurants/216757.gif",
                "isTestRestaurant": false,
                "deals": [],
                "tags": [],
                "cuisines": [
                    {"name": "Japanese", "uniqueName": "japanese"},
                    {"name": "Sushi", "uniqueName": "sushi"},
                    {"name": "Ramen", "uniqueName": "ramen"}
                ],
                "availability": {
                    "delivery": {
                        "isOpen": true,
                        "canPreOrder": false,
                        "isTemporarilyOffline": false,
                        "nextAvailability": {"from": "2025-04-01T16:20:00"},
                        "etaMinutes": {"rangeLower": 15, "rangeUpper": 30}
                    }
                }},{
                        "id": "147222",
                        "name": "Sushi Place But Its Really Long This Time",
                        "uniqueName": "sushi-place",
                        "address": {
                            "city": "Brighton and Hove and Everywhere",
                            "firstLine": "123 Sushi Street But Its Really Really Really Really Really Long This Time",
                            "postalCode": "RG23 8BH",
                            "location": {
                                "type": "Point",
                                "coordinates": [-0.12345, 0.67890]
                            }
                        },
                        "rating": {
                            "count": 123,
                            "starRating": 4.5,
                            "userRating": 3
                        },
                        "isNew": false,
                        "driveDistanceMeters": 500,
                        "openingTimeLocal": "2025-04-01T10:00:00",
                        "deliveryOpeningTimeLocal": "2025-04-01T10:00:00",
                        "deliveryEtaMinutes": {"rangeLower": 15, "rangeUpper": 30},
                        "isCollection": true,
                        "isDelivery": true,
                        "isOpenNowForCollection": true,
                        "isOpenNowForDelivery": true,
                        "isOpenNowForPreorder": false,
                        "isTemporarilyOffline": false,
                        "deliveryCost": 1.99,
                        "minimumDeliveryValue": 10.0,
                        "defaultDisplayRank": 1,
                        "isTemporaryBoost": false,
                        "isPremier": false,
                        "logoUrl": "no",
                        "isTestRestaurant": false,
                        "deals": [],
                        "tags": [],
                        "cuisines": [
                            {"name": "Japanese", "uniqueName": "japanese"},
                            {"name": "Sushi", "uniqueName": "sushi"},
                            {"name": "Ramen", "uniqueName": "ramen"},
                            {"name": "ReallyLongAndInsaneDetailsHere", "uniqueName": "long-cuisine"},
                            {"name": "ReallyLongAndInsaneDetailsHere", "uniqueName": "long-cuisine"},
                            {"name": "ReallyLongAndInsaneDetailsHere", "uniqueName": "long-cuisine"}
                        ],
                        "availability": {
                            "delivery": {
                                "isOpen": true,
                                "canPreOrder": false,
                                "isTemporarilyOffline": false,
                                "nextAvailability": {"from": "2025-04-01T16:20:00"},
                                "etaMinutes": {"rangeLower": 15, "rangeUpper": 30}
                            }
                        }
                    }
        ]
        """
        // And 'decode' it
        let data = json.data(using: .utf8)!
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Restaurant].self, from: data)
        } catch {
            fatalError("Decoding failed: \(error)")
        }
    }()
}
