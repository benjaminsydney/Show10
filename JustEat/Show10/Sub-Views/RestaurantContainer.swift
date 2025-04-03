//
//  RestaurantCard.swift
//  Show10
//
//  Created by Ben Foard on 26/3/25.
//


import SwiftUI

struct RestaurantContainer: View {
    @Binding var offset: CGFloat
    @GestureState private var dragState = CGSize.zero
    let rankedRestaurants: [RankedRestaurant]
    @Binding var selectedRestaurantID: String?

    init(offset: Binding<CGFloat>, rankedRestaurants: [RankedRestaurant] = [], selectedRestaurantID: Binding<String?>) {
        self._offset = offset
        self.rankedRestaurants = rankedRestaurants
        self._selectedRestaurantID = selectedRestaurantID
    }

    var body: some View {
        VStack {
            HStack{
                Capsule()
                    .frame(width: 40, height: 6)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }
            TabView(selection: $selectedRestaurantID) {
                ForEach(rankedRestaurants) { ranked in
                    IndividualRestaurant(restaurant: ranked.restaurant, placement: ranked.placement)
                        .tag(ranked.restaurant.id)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            // Spaced else the page selection dots overlay the home bar/safe area
            Spacer()
            Spacer()
        }
        .frame(height: 350)
        .background(.thinMaterial)
        .background(LinearGradient(
            colors: [.jetOrange, .aubergine],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ).opacity(0.4))
        .cornerRadius(20)
        .offset(y: offset + dragState.height)
        .gesture(
            DragGesture()
                .updating($dragState) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    if value.translation.height > 100 {
                        withAnimation { offset = 250 }
                    } else {
                        withAnimation { offset = 34 }
                    }
                }
        )
        .animation(.easeInOut, value: dragState)
    }
}
