//
//  BenRatingTag.swift
//  Show10
//
//  Created by Ben Foard on 26/3/25.
//

import SwiftUI

struct GrayStars: View {
    let fill: CGFloat
    let starSize: CGFloat = 15
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(systemName: "star")
                .resizable()
                .frame(width: starSize, height: starSize)
                .foregroundColor(.gray)
            
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: starSize, height: starSize)
                .foregroundColor(.jetOrange)
                .mask(
                    GeometryReader { geo in
                        Rectangle()
                            .frame(width: geo.size.width * fill)
                    }
                )
        }
    }
}

struct RatingTag: View {
    let rating: Double
    
    var body: some View {
        HStack{
            Spacer()
            HStack(spacing: 2) {
                Text(String(format: "%.1f", rating))
                    .padding(.trailing, 2)
                ForEach(0..<5) { index in
                    let fill = CGFloat(min(max(rating - Double(index), 0), 1))
                    GrayStars(fill: fill)
                }
            }
            .fixedSize()
        }
    }
}

struct RatingTag_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RatingTag(rating: 4.5)
            RatingTag(rating: 3)
            RatingTag(rating: 0)
            RatingTag(rating: -1)
            RatingTag(rating: 5)
            RatingTag(rating: 10)
        }
        .padding()
    }
}
