//
//  ContentView.swift
//  JustEat
//
//  Created by Ben Foard on 26/3/25.
//

import SwiftUI

struct ContentView: View {
    @State private var postcode: String = ""
    @State private var isValidPostcode: Bool = true
    
    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            HStack{
                TextField("Enter UK Postcode", text: $postcode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .border(.charcoal)
                Button(action: {
                    if isValidUKPostcode(postcode) {
                        isValidPostcode = true
                        print("Searching: \(postcode)")
                    } else {
                        isValidPostcode = false
                        print("Not UK Postcode")
                    }
                }) {
                    Text("Search")
                        .padding()
                        .foregroundStyle(.charcoal)
                        .background(.jetOrange)
                }
                .cornerRadius(10)
            }
            .padding()
            Spacer()
        }
        .background(.mozzarella)
    }
}

    func isValidUKPostcode(_ postcode: String) -> Bool {
        let trimmed = postcode.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let regex = #"^[A-Z]{1,2}[0-9][0-9A-Z]?\s?[0-9][A-Z]{2}$"#
        return trimmed.range(of: regex, options: .regularExpression) != nil
    }
