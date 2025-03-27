//
//  ResultOrderTag.swift
//  Just Eat
//
//  Created by Ben Foard on 26/3/25.
//

import SwiftUI

struct ResultOrderTag: View {
    
    let placement: Int
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.jetOrange)
                .frame(width: 40, height: 40)
            Text("\(placement)")
                .foregroundStyle(.mozzarella)
                .bold(true)
                .font(.title)
        }
    }
}

#Preview {
    ResultOrderTag(placement: 10)
}
