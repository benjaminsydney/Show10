//
//  ResultsView.swift
//  Show10
//
//  Created by Ben Foard on 27/3/25.
//

import SwiftUI
import MapKit

struct ResultsView: View {
    @Binding var postcode: String
    @Binding var hasSearched: Bool
    @Binding var isValidPostcode: Bool
    @Binding var showPostcodeError: Bool
    @Binding var isLoading: Bool
    @State private var selectedRestaurantID: String?
    @State private var offset: CGFloat = 35
    @Binding var rankedRestaurants: [RankedRestaurant]
    var onSearch: () -> Void
    var namespace: Namespace.ID

    init(postcode: Binding<String>,
         hasSearched: Binding<Bool>,
         isValidPostcode: Binding<Bool>,
         showPostcodeError: Binding<Bool>,
         isLoading: Binding<Bool>,
         restaurants: [Restaurant] = [],
         rankedRestaurants: Binding<[RankedRestaurant]>,
         onSearch: @escaping () -> Void,
         namespace: Namespace.ID) {
        self._postcode = postcode
        self._hasSearched = hasSearched
        self._isValidPostcode = isValidPostcode
        self._showPostcodeError = showPostcodeError
        self._isLoading = isLoading
        self._rankedRestaurants = rankedRestaurants
        self.onSearch = onSearch
        self.namespace = namespace
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
            .id(hasSearched)
            .mapControlVisibility(.hidden)
            .ignoresSafeArea()
            VStack {
                HStack {
                    PostcodeSearchBar(postcode: $postcode, isLoading: $isLoading, showPostcodeError: $showPostcodeError, isSearchMode: false, onSearch: onSearch)
                        .matchedGeometryEffect(id: "postcodeBar", in: namespace)
                }
                .padding(.horizontal)
                Spacer()
            }
            RestaurantContainer(offset: $offset, rankedRestaurants: rankedRestaurants, selectedRestaurantID: $selectedRestaurantID)
        }
    }
}
