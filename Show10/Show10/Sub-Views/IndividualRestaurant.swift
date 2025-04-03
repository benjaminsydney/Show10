//
//  IndividualRestaurant.swift
//  Show10
//
//  Created by Ben Foard on 26/3/25.
//

import Foundation
import SwiftUI

let maxIconSize: CGFloat = 60

struct IndividualRestaurant: View {
    
    let restaurant: Restaurant
    let placement: Int
    let placementSize: CGFloat = 40
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack(alignment: .leading) {
                
                HStack {
                    
                    VStack (alignment: .leading) {
                        Text(restaurant.name)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text(restaurant.address)
                            .font(.footnote)
                    }
                    
                    Spacer()
                    
                    AsyncImage(url: URL(string: restaurant.logoUrl)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(width: maxIconSize, height: maxIconSize)
                                .shadow(color: .charcoal.opacity(0.5), radius: 6, x: 0, y: 4)
                        } else if phase.error != nil {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.jetOrange)
                                    .frame(width: maxIconSize, height: maxIconSize)
                                Text("?")
                                    .foregroundStyle(.white)
                                    .bold()
                            }
                        }
                    }
                    
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 10) {
                        ForEach(restaurant.cuisines, id: \.self) { cuisine in
                            CuisineTag(label: cuisine)
                        }
                    }
                    .padding(.vertical, 4)
                }
                RatingTag(rating: restaurant.starRating)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.charcoal)
            .background(.mozzarella.opacity(0.6))
            .background(.thinMaterial)
            .cornerRadius(16)
            .shadow(color: .charcoal.opacity(0.5), radius: 6, x: 0, y: 4)
            
            ZStack (alignment: .top) {
                HStack {
                    Spacer()
                    ResultOrderTag(placement: placement, size: placementSize)
                    Spacer()
                }
            }
            .offset(y: -maxIconSize / 2)
        }
        .padding([.top, .horizontal])
    }
}

struct IndividualRestaurant_Previews: PreviewProvider {
    static var previews: some View {
        IndividualRestaurant(restaurant: FakeData.fakeRestaurants.first!, placement: 4)
    }
}

struct IndividualRestaurant_Previews2: PreviewProvider {
    static var previews: some View {
        IndividualRestaurant(restaurant: FakeData.fakeRestaurants.last!, placement: 4)
    }
}
