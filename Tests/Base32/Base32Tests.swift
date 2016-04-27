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
        assertASCIIString("", encodesToString: "")
        assertASCIIString("f", encodesToString: "MY======")
        assertASCIIString("fo", encodesToString: "MZXQ====")
        assertASCIIString("foo", encodesToString: "MZXW6===")
        assertASCIIString("foob", encodesToString: "MZXW6YQ=")
        assertASCIIString("fooba", encodesToString: "MZXW6YTB")
        assertASCIIString("foobar", encodesToString: "MZXW6YTBOI======")
    }

    private func assertASCIIString(_ source: String, encodesToString destination: String) {
        if let data = (source as NSString).data(using: NSASCIIStringEncoding) {
            let result = base32(bytes: data.byteArray)
            XCTAssertEqual(result, destination, "\"\(source)\" encoded to \"\(result)\" (Expected \"\(destination)\")")
        } else {
            XCTFail("Could not convert \"\(source)\" to NSData")
        }
    }

}
