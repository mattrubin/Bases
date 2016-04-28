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
    let rfcTestVectors = [("", ""),
                          ("f", "66"),
                          ("fo", "666F"),
                          ("foo", "666F6F"),
                          ("foob", "666F6F62"),
                          ("fooba", "666F6F6261"),
                          ("foobar", "666F6F626172")]

    func testRFC() {
        for (sourceString, encodedString) in rfcTestVectors {
            assert(ASCII: sourceString, encodesTo: encodedString)
            assert(encodedString: encodedString, decodesToASCII: sourceString)
        }
    }

    private func assert(ASCII sourceString: String, encodesTo encodedString: String, file: StaticString = #file, line: UInt = #line) {
        if let data = sourceString.data(using: NSASCIIStringEncoding) {
            let result = Base16.encode(data: data)
            XCTAssertEqual(result, encodedString, "ASCII string \"\(sourceString)\" encoded to \"\(result)\" (expected result: \"\(encodedString)\")", file: file, line: line)
        } else {
            XCTFail("Could not convert ASCII string \"\(sourceString)\" to NSData", file: file, line: line)
        }
    }

    private func assert(encodedString: String, decodesToASCII sourceString: String, file: StaticString = #file, line: UInt = #line) {
        let data = Base16.decode(string: encodedString)!
        if let result = String(data: data, encoding: NSASCIIStringEncoding) {
            XCTAssertEqual(result, sourceString, "Encoded string \"\(encodedString)\" decoded to ASCII string \"\(result)\" (expected result: \"\(sourceString)\")", file: file, line: line)
        } else {
            XCTFail("Could not convert decoded data to ASCII string", file: file, line: line)
        }
    }
}
