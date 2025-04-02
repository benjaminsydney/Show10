//
//  CuisineTag.swift
//  Just Eat
//
//  Created by Ben Foard on 26/3/25.
//

import SwiftUI

struct CuisineTag: View {
    let label: String
    var body: some View {
        Text(label)
            .foregroundStyle(.charcoal)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.cupcake))
            .fixedSize()
    }
}

#Preview {
        CuisineTag(label: "Italian")
}
