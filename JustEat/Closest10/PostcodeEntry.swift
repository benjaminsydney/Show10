//
//  PostcodeEntry.swift
//  Just Eat
//
//  Created by Ben Foard on 26/3/25.
//

import SwiftUI
import MapKit
import CoreLocation

// NOTE: Postcode passes but is wrong = Ct179dm

struct PostcodeEntry: View {
    @State private var postcode: String
    @State private var isValidPostcode: Bool
    @State private var hasSearched: Bool
    @State private var startAnimation: Bool
    
    let restaurants: [Restaurant]
    
    init(restaurants: [Restaurant] = []) {
        self.restaurants = restaurants
        _postcode = State(initialValue: "")
        _isValidPostcode = State(initialValue: false)
        _hasSearched = State(initialValue: false)
        _startAnimation = State(initialValue: false)
    }

    var body: some View {
        ZStack {
            if hasSearched && isValidPostcode {
                ResultsView(
                    postcode: $postcode,
                    hasSearched: $hasSearched,
                    isValidPostcode: $isValidPostcode, restaurants: restaurants
                )
                .transition(.move(edge: .bottom))
            } else {
                entryView
                    .transition(.move(edge: .top))
            }
        }
        .animation(.easeInOut, value: hasSearched)
    }

    var entryView: some View {
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
                Spacer()
                Image(.jetLogo)
                    .resizable()
                    .frame(width: 200, height: 200)
                Spacer()
                VStack(spacing: 16) {
                    Text("Find your closest 10 restaurants.")
                        .foregroundStyle(.mozzarella)

                    PostcodeSearchBar(postcode: $postcode) {
                        isValidPostcode = isValidUKPostcode(postcode)
                        withAnimation {
                            hasSearched = true
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

func isValidUKPostcode(_ postcode: String) -> Bool {
    let trimmed = postcode.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
    let regex = #"^[A-Z]{1,2}[0-9][0-9A-Z]?\s?[0-9][A-Z]{2}$"#
    return trimmed.range(of: regex, options: .regularExpression) != nil
}
