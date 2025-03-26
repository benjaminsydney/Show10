//
//  JustEatTests.swift
//  JustEatTests
//
//  Created by Ben Foard on 26/3/25.
//

import Testing
@testable import JustEat

struct JustEatTests {

    @Test func validPostcodeIsValid() throws {
        let validPostcodes = ["EC4M 7RF", "W1A 0AX", "M1 1AE", "B33 8TH", "SW1A 1AA"]
        for postcode in validPostcodes {
            #expect(isValidUKPostcode(postcode) == true, "Expected \(postcode) to be valid")
        }
    }
    
    @Test func invalidPostcodeIsInvalid() throws {
        let invalidPostcodes = ["12345", "XYZ", "", "A1", " ", "RG2 3!:"]
        for postcode in invalidPostcodes {
            #expect(isValidUKPostcode(postcode) == false, "Expected \(postcode) to be invalid")
        }
    }

}
