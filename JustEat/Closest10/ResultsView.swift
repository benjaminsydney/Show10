//
//  ResultsView.swift
//  Just Eat
//
//  Created by Ben Foard on 27/3/25.
//

import SwiftUI
import MapKit

struct ResultsView: View {
    @Binding var postcode: String
    @Binding var hasSearched: Bool
    @Binding var isValidPostcode: Bool
    @State private var selectedRestaurantID: String?
    @State private var offset: CGFloat = 35
    @State private var rankedRestaurants: [RankedRestaurant] = []
    
    init(postcode: Binding<String>,
         hasSearched: Binding<Bool>,
         isValidPostcode: Binding<Bool>,
         restaurants: [Restaurant] = []) {
        self._postcode = postcode
        self._hasSearched = hasSearched
        self._isValidPostcode = isValidPostcode
        _rankedRestaurants = State(initialValue: rankedRestaurants)
    }
    
    let mapPlacementSize: CGFloat = 20

    var body: some View {
        ZStack(alignment: .bottom) {
            Map() {
                ForEach(rankedRestaurants) { ranked in
                    Annotation("", coordinate: ranked.restaurant.coordinates) {
                        // First result not automatically selected so have to do it here
                        let isSelected: Bool = {
                            if let selected = selectedRestaurantID {
                                return ranked.restaurant.id == selected
                            } else {
                                return rankedRestaurants.first?.restaurant.id == ranked.restaurant.id
                            }
                        }()
                        if !isSelected {
                            ResultOrderTag(placement: ranked.placement, size: mapPlacementSize)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        selectedRestaurantID = ranked.restaurant.id
                                    }
                                }
                        } else {
                            ResultOrderTag(placement: ranked.placement, size: mapPlacementSize * 2)
                        }
                    }
                    
                }
            }
            .mapControlVisibility(.hidden)
            .ignoresSafeArea()
            VStack {
                HStack {
                    PostcodeSearchBar(postcode: $postcode) {
                        isValidPostcode = isValidUKPostcode(postcode)
                        if isValidPostcode {
                            fetchRestaurants()
                        }
                        hasSearched = true
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            RestaurantContainer(offset: $offset, rankedRestaurants: rankedRestaurants, selectedRestaurantID: $selectedRestaurantID)
        }
        .onAppear {
            print("RestaurantContainer appeared with \(rankedRestaurants.count) restaurants")
            if isValidPostcode && !postcode.isEmpty {
                fetchRestaurants()
            }
        }
    }
    
    private func fetchRestaurants() {
        APIRequest.shared.fetchRestaurants(for: postcode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetched):
                    let sortedRestaurants = fetched.sorted { $0.driveDistanceMeters < $1.driveDistanceMeters }
                    let top10 = sortedRestaurants.prefix(10)
                    
                    self.rankedRestaurants = top10.enumerated().map { (index, restaurant) in
                        RankedRestaurant(restaurant: restaurant, placement: index + 1)
                    }
                    print("Fetched \(self.rankedRestaurants.count) restaurants")
                case .failure(let error):
                    print("API Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
