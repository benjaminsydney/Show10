//
//  RatingTag.swift
//  Just Eat
//
//  Created by Ben Foard on 26/3/25.
//

import SwiftUI

struct RatingTag: View {
    
    let stars: Int
    
    var body: some View {
        VStack{
            if !(0...5).contains(stars) {
                Text("Unrated")
            } else {
                Text("Rating: \(stars)/5")
                //
                // Like the look of the stars but the brief said "as a number"
                //
                // Text(String(repeating: "⭐️", count: stars))
                //
            }
        }
        .foregroundStyle(.charcoal)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.cupcake))
        .fixedSize()
    }
}

#Preview {
    RatingTag(stars: -1)
}

#Preview {
    RatingTag(stars: 5)
}

#Preview {
    RatingTag(stars: 1)
}

#Preview {
    RatingTag(stars: 0)
}
