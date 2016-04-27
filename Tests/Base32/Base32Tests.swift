//
//  Base32Tests.swift
//  Base32Tests
//
//  Created by Matt Rubin on 3/28/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

import XCTest
import Base32


extension NSData {
    var byteArray: [UInt8] {
        let count = self.length / sizeof(UInt8)
        var bytesArray = Array<UInt8>(repeating: 0, count: count)
        self.getBytes(&bytesArray, length:count * sizeof(UInt8))
        return bytesArray
    }
}

class Base32Tests: XCTestCase {

    func testRFC() {
        assert(ASCII: "", encodesTo: "")
        assert(ASCII: "f", encodesTo: "MY======")
        assert(ASCII: "fo", encodesTo: "MZXQ====")
        assert(ASCII: "foo", encodesTo: "MZXW6===")
        assert(ASCII: "foob", encodesTo: "MZXW6YQ=")
        assert(ASCII: "fooba", encodesTo: "MZXW6YTB")
        assert(ASCII: "foobar", encodesTo: "MZXW6YTBOI======")
    }

    private func assert(ASCII sourceString: String, encodesTo encodedString: String, file: StaticString = #file, line: UInt = #line) {
        if let data = (sourceString as NSString).data(using: NSASCIIStringEncoding) {
            let result = base32(bytes: data.byteArray)
            XCTAssertEqual(result, encodedString, "ASCII string \"\(sourceString)\" encoded to \"\(result)\" (expected result: \"\(encodedString)\")", file: file, line: line)
        } else {
            XCTFail("Could not convert ASCII string \"\(sourceString)\" to NSData", file: file, line: line)
        }
    }

}
