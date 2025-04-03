//
//  PostcodeSearchBar.swift
//  Show10
//
//  Created by Ben Foard on 26/3/25.
//

import Foundation
import SwiftUI

struct PostcodeSearchBar: View {
    
    @Binding var postcode: String
    @Binding var isLoading: Bool
    @Binding var showPostcodeError: Bool
    var isSearchMode: Bool
    var onSearch: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                if isSearchMode {
                    TextField("Enter UK Postcode", text: $postcode)
                        .padding(.vertical, 12)
                        .textContentType(.postalCode)
                        .padding(.horizontal)
                        .background(.thinMaterial)
                        .cornerRadius(50)

                    Button {
                        if isValidUKPostcode(postcode) {
                            onSearch()
                        } else {
                            showPostcodeError = true
                        }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding(12)
                                .tint(Color.white)
                                .background(Circle().fill(.jetOrange))
                        } else {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.mozzarella)
                                .padding(12)
                                .background(Circle().fill(isValidUKPostcode(postcode) ? .jetOrange : .aubergine))
                        }
                    }

                } else {
                    Button {
                        postcode = ""
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.charcoal)
                            Text("Back")
                                .foregroundColor(.charcoal)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .background(.thinMaterial)
                        .background(.jetOrange)
                        .cornerRadius(50)
                    }
                }
            }
            .padding(.horizontal)

            if showPostcodeError {
                Text("No data found. Try again.")
                    .font(.subheadline)
                    .foregroundColor(.charcoal)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(10)
                    .bold()
            }
        }
        .cornerRadius(10)
        .padding()
    }
}

#Preview {
    PostcodeSearchBar(
        postcode: .constant("BN1 6PB"), isLoading: .constant(false),
        showPostcodeError: .constant(false), isSearchMode: true,
        onSearch: { print("Search tapped") }
    )
}

#Preview {
    PostcodeSearchBar(
        postcode: .constant("BN1 6PB"), isLoading: .constant(false),
        showPostcodeError: .constant(true), isSearchMode: true,
        onSearch: { print("Search tapped") }
    )
    .background(Color.jetOrange)
}

#Preview {
    PostcodeSearchBar(
        postcode: .constant("BN1 6PB"), isLoading: .constant(true),
        showPostcodeError: .constant(false), isSearchMode: true,
        onSearch: { print("Search tapped") }
    )
}

#Preview {
    PostcodeSearchBar(
        postcode: .constant(""), isLoading: .constant(false),
        showPostcodeError: .constant(false), isSearchMode: false,
        onSearch: { print("Search tapped") }
    )
}
