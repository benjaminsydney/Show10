//
//  PostcodeEntry.swift
//  Just Eat
//
//  Created by Ben Foard on 26/3/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct PostcodeEntry: View {
    @State private var postcode: String = ""
    @State private var isValidPostcode: Bool = false
    @State private var hasSearched: Bool = false
    @State private var startAnimation: Bool = false

    var body: some View {
        ZStack {
            if hasSearched && isValidPostcode {
                ResultsView(
                    postcode: $postcode,
                    hasSearched: $hasSearched,
                    isValidPostcode: $isValidPostcode
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
                    Text("Please enter a UK Postcode")
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

// MARK: Preview
#Preview {
    PostcodeEntry()
}
