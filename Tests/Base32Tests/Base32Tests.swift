//
//  Base32Tests.swift
//  Base32Tests
//
//  Copyright (c) 2015-2016 Matt Rubin and the Bases authors
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import XCTest
import Base32


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
        if let data = sourceString.data(using: String.Encoding.ascii) {
            let result = Base32.encode(data)
            XCTAssertEqual(result, encodedString, "ASCII string \"\(sourceString)\" encoded to \"\(result)\" (expected result: \"\(encodedString)\")", file: file, line: line)
        } else {
            XCTFail("Could not convert ASCII string \"\(sourceString)\" to NSData", file: file, line: line)
        }
    }

}
