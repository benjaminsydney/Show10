//
//  RestaurantCard.swift
//  Just Eat
//
//  Created by Ben Foard on 26/3/25.
//


import SwiftUI

struct RestaurantContainer: View {
    @Binding var offset: CGFloat
    @GestureState private var dragState = CGSize.zero

    var body: some View {
        VStack {
            Capsule()
                .frame(width: 40, height: 6)
                .foregroundColor(.gray)
                .padding(.top, 8)
                .padding(.bottom, 4)
            Spacer().frame(height: 16)
            TabView {
                ForEach(0..<10)R { index in
                    IndividualRestaurant()
                        .padding(.horizontal)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .frame(height: 500)
        }
        .frame(height: 550)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .background(.jetOrange.opacity(0.3))
        .cornerRadius(20)
        .offset(y: offset + dragState.height)
        .gesture(
            DragGesture()
                .updating($dragState) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    if value.translation.height > 100 {
                        withAnimation { offset = 400 }
                    } else {
                        withAnimation { offset = 35 }
                    }
                }
        )
        .animation(.easeInOut, value: dragState)
    }
}

#Preview {
    ZStack{
        Color.black
            .ignoresSafeArea()
        RestaurantContainer(offset: .constant((30)))
    }
}
