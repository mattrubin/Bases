//
//  Base16Tests.swift
//  Base16Tests
//
//  Created by Matt Rubin on 4/27/16.
//  Copyright © 2016 Matt Rubin. All rights reserved.
//

import XCTest
import Base16

class Base16Tests: XCTestCase {
    func testRFC() {
        let rfcTestVectors = [("", ""),
                              ("f", "66"),
                              ("fo", "666F"),
                              ("foo", "666F6F"),
                              ("foob", "666F6F62"),
                              ("fooba", "666F6F6261"),
                              ("foobar", "666F6F626172")]

        for (decodedString, encodedString) in rfcTestVectors {
            guard let decodedData = decodedString.data(using: NSASCIIStringEncoding) else {
                XCTFail("Could not convert ASCII string \"\(decodedString)\" to NSData")
                continue
            }

            let encodedResult = Base16.encode(data: decodedData)
            XCTAssertEqual(encodedResult, encodedString, "ASCII string \"\(decodedString)\" encoded to \"\(encodedResult)\" (expected \"\(encodedString)\")")

            let decodedResult = Base16.decode(string: encodedString)!
            XCTAssertEqual(decodedResult, decodedData, "Encoded string \"\(encodedString)\" decoded to data \"\(decodedResult)\" (expected \"\(decodedData)\")")
        }
    }
}
