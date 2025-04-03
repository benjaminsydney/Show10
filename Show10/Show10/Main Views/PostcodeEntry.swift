//
//  PostcodeEntry.swift
//  Show10
//
//  Created by Ben Foard on 26/3/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct PostcodeEntry: View {
    @State private var postcode: String
    @State private var isValidPostcode: Bool
    @State private var hasSearched: Bool
    @State private var startAnimation: Bool
    @State private var showPostcodeError: Bool
    @State private var isLoading: Bool = false
    @State private var rankedRestaurants: [RankedRestaurant] = []
    @State private var closestMode: Bool = false
    @Namespace private var postcodeEntryNamespace
    
    let restaurants: [Restaurant]
    
    init(restaurants: [Restaurant] = []) {
        self.restaurants = restaurants
        _postcode = State(initialValue: "")
        _isValidPostcode = State(initialValue: false)
        _hasSearched = State(initialValue: false)
        _startAnimation = State(initialValue: false)
        _showPostcodeError = State(initialValue: false)
    }

    var body: some View {
        ZStack {
            if hasSearched {
                ResultsView(
                    postcode: $postcode,
                    hasSearched: $hasSearched,
                    isValidPostcode: $isValidPostcode, showPostcodeError: $showPostcodeError ,isLoading: $isLoading, restaurants: restaurants, rankedRestaurants: $rankedRestaurants, onSearch: onSearchTapped, namespace: postcodeEntryNamespace
                )
                .transition(.opacity)
            } else {
                startScreen
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: hasSearched)
        .onChange(of: postcode) {
            if postcode == "" && !isLoading && hasSearched {
                hasSearched = false
            }
        }
    }

    var startScreen: some View {
        ZStack {
            LinearGradient(
                colors: [.jetOrange, .aubergine],
                startPoint: startAnimation ? .topLeading : .bottomLeading,
                endPoint: startAnimation ? .bottomTrailing : .topTrailing
            )
            .onAppear {
                withAnimation(.linear(duration: 5.0).repeatForever()) {
                    startAnimation.toggle()
                }
            }
            .ignoresSafeArea()

            VStack {
                HStack{
                    Picker("Search Mode", selection: $closestMode) {
                        Text("First API 10").tag(false)
                        Text("Closest 10").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                }
                Spacer()
                Image(.jetLogo)
                    .resizable()
                    .frame(width: 200, height: 200)
                Spacer()
                VStack(spacing: 16) {
                    Text("Find 10 restaurants nearby!")
                        .foregroundStyle(.mozzarella)

                    PostcodeSearchBar(
                        postcode: $postcode,
                        isLoading: $isLoading,
                        showPostcodeError: $showPostcodeError, isSearchMode: true,
                        onSearch: onSearchTapped
                    )
                    .matchedGeometryEffect(id: "postcodeBar", in: postcodeEntryNamespace)
                }
                Spacer()
            }
            .padding()
        }
    }
    
    func onSearchTapped() {
        isValidPostcode = isValidUKPostcode(postcode)

        if isValidPostcode {
            showPostcodeError = false
            fetchRestaurants()
        } else {
            showPostcodeError = true
        }
    }
    
    private func fetchRestaurants() {
        isLoading = true
        
        Task {
            do {
                let fetched = try await APIRequest.shared.fetchRestaurants(for: postcode)
                showPostcodeError = false
                
                let top10: [Restaurant]
                if closestMode {
                    top10 = fetched.sorted { $0.driveDistanceMeters < $1.driveDistanceMeters }.prefix(10).map { $0 }
                } else {
                    top10 = fetched.prefix(10).map { $0 }
                }
                
                self.rankedRestaurants = top10.enumerated().map { index, restaurant in
                    RankedRestaurant(restaurant: restaurant, placement: index + 1)
                }

                print("API Fetched \(self.rankedRestaurants.count) restaurants.")
                hasSearched = true
            } catch {
                print("API Error: \(error.localizedDescription)")
                showPostcodeError = true
            }
            
            isLoading = false
        }
    }
    
}

func isValidUKPostcode(_ postcode: String) -> Bool {
    let trimmed = postcode.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
    let regex = #"^[A-Z]{1,2}[0-9][0-9A-Z]?\s?[0-9][A-Z]{2}$"#
    return trimmed.range(of: regex, options: .regularExpression) != nil
}
