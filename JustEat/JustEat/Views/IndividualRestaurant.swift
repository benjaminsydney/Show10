//
//  IndividualRestaurant.swift
//  Just Eat
//
//  Created by Ben Foard on 26/3/25.
//

import Foundation
import SwiftUI

let maxIconSize: CGFloat = 130
let maxImageSize: CGFloat = 300

let resultPlacement: Int = 2

struct IndividualRestaurant: View {
    var body: some View {
        ZStack(alignment: .top) {
            
            // Card content
            VStack(alignment: .leading) {
                Spacer().frame(height: maxIconSize / 4)
                
                Image(.tempFood)
                    .resizable()
                    .frame(width: maxImageSize, height: maxImageSize / 1.5)
                    .cornerRadius(10)
                
                Text("McDonalds")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("1 Kings Road 1 Kings Road 1 Kings Road")
                    .font(.footnote)
                
                HStack {
                    Spacer()
                    HStack {
                        CuisineTag(label: "Fast Food")
                        RatingTag(stars: 1)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.charcoal)
            .background(.thinMaterial)
            .cornerRadius(16)
            .shadow(color: .charcoal.opacity(0.5), radius: 6, x: 0, y: 4)
            
            ZStack{
                HStack {
                    ResultOrderTag(placement: resultPlacement)
                    Spacer()
                }
                HStack{
                    Spacer()
                    Image(.tempLogo)
                        .resizable()
                        .mask(Circle())
                        .frame(width: maxIconSize, height: maxIconSize)
                        .shadow(radius: 4)
                    Spacer()
                }
            }
            .offset(y: -maxIconSize / 2)
        }
        .padding([.top, .horizontal])
    }
}

// MARK: Preview
#Preview {
    ZStack{
        Color.gray
        IndividualRestaurant()
    }
}
