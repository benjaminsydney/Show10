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

    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 50.84497, longitude: -0.14397), // Default: Brighton
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    @State private var cardOffset: CGFloat = 35

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $mapRegion)
                .ignoresSafeArea()
            VStack {
                HStack {
                    PostcodeSearchBar(postcode: $postcode) {
                        isValidPostcode = isValidUKPostcode(postcode)
                        hasSearched = true
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            RestaurantContainer(offset: $cardOffset)
        }
        .onChange(of: hasSearched) {
            if hasSearched && isValidPostcode {
                centerMap(on: postcode)
            }
        }
    }

    //MARK: Incomplete center map when updating?
    func centerMap(on postcode: String) {
        CLGeocoder().geocodeAddressString(postcode) { placemarks, error in
            if let loc = placemarks?.first?.location {
                // Have to adjust the coordinates so that the 'center' of the map is above the restaurant card
                let adjustedCoordinate = CLLocationCoordinate2D(
                    latitude: loc.coordinate.latitude - 0.025,
                    longitude: loc.coordinate.longitude
                )
                // Zoom
                let newRegion = MKCoordinateRegion(
                    center: adjustedCoordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                // Fly-to
                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        mapRegion = newRegion
                    }
                }
            } else {
                print("Error: getting coordinates for \(postcode)")
            }
        }
    }
}

// MARK: Preview
struct ResultsView_PreviewWrapper: View {
    @State private var postcode: String = "BN1 6PB"
    @State private var hasSearched: Bool = true
    @State private var isValidPostcode: Bool = true

    var body: some View {
        ResultsView(
            postcode: $postcode,
            hasSearched: $hasSearched,
            isValidPostcode: $isValidPostcode
        )
    }
}

#Preview {
    ResultsView_PreviewWrapper()
}
