//
//  Base16Tests.swift
//  Base16Tests
//
//  Created by Matt Rubin on 4/27/16.
//  Copyright © 2016 Matt Rubin. All rights reserved.
//

import XCTest
@testable import Base16

class Base16Tests: XCTestCase {
    func testRFC() {
        assert(ASCII: "", encodesTo: "")
        assert(ASCII: "f", encodesTo: "66")
        assert(ASCII: "fo", encodesTo: "666F")
        assert(ASCII: "foo", encodesTo: "666F6F")
        assert(ASCII: "foob", encodesTo: "666F6F62")
        assert(ASCII: "fooba", encodesTo: "666F6F6261")
        assert(ASCII: "foobar", encodesTo: "666F6F626172")
    }

    private func assert(ASCII sourceString: String, encodesTo encodedString: String, file: StaticString = #file, line: UInt = #line) {
        if let data = sourceString.data(using: NSASCIIStringEncoding) {
            let result = Base16.encode(data: data)
            XCTAssertEqual(result, encodedString, "ASCII string \"\(sourceString)\" encoded to \"\(result)\" (expected result: \"\(encodedString)\")", file: file, line: line)
        } else {
            XCTFail("Could not convert ASCII string \"\(sourceString)\" to NSData", file: file, line: line)
        }
    }
}
