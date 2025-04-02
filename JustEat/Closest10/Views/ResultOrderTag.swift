//
//  ResultOrderTag.swift
//  Just Eat
//
//  Created by Ben Foard on 26/3/25.
//

import SwiftUI

struct ResultOrderTag: View {
    
    let placement: Int
    let size: CGFloat
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.jetOrange)
                .frame(width: size, height: size)
                .shadow(radius: 1)
            Text("\(placement)")
                .foregroundStyle(.mozzarella)
                .bold(true)
                .font(.system(size: size * 0.7, weight: .bold))
        }
    }
}

#Preview {
    ResultOrderTag(placement: 10, size: 40)
    ResultOrderTag(placement: 10, size: 20)
}
