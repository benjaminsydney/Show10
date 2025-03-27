//
//  PostcodeSearchBar.swift
//  Just Eat
//
//  Created by Ben Foard on 26/3/25.
//

import Foundation
import SwiftUI

struct PostcodeSearchBar: View {
    
    @Binding var postcode: String
    var onSearch: () -> Void

    var body: some View {
        VStack {
            HStack {
                TextField("Enter UK Postcode", text: $postcode)
                    .padding(.vertical, 12)
                    .padding(.horizontal)
                    .background(Color.white)
                    .foregroundStyle(.charcoal)
                    .cornerRadius(50)
                Button {
                    onSearch()
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.mozzarella)
                        .padding(12)
                        .background(Circle().fill(isValidUKPostcode(postcode) ? .jetOrange : .aubergine))
                }
            }
            .padding(.horizontal)
        }
        .cornerRadius(10)
        .shadow(color: .mozzarella.opacity(0.3), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}

#Preview {
    PostcodeSearchBar(
        postcode: .constant("BN1 6PB"),
        onSearch: { print("Search tapped") }
    )
}
