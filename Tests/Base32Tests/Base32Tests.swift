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
        guard let data = sourceString.data(using: String.Encoding.ascii) else {
            XCTFail("Could not convert ASCII string \"\(sourceString)\" to Data", file: file, line: line)
            return
        }

        let result = Base32.encode(data)
        XCTAssertEqual(result, encodedString, "ASCII string \"\(sourceString)\" encoded to \"\(result)\" (expected result: \"\(encodedString)\")", file: file, line: line)

        do {
            let resultData = try Base32.decode(encodedString)
            XCTAssertEqual(resultData, data, "Base32 string \"\(encodedString)\" decoded to \"\(resultData)\" (expected result: \"\(data)\")", file: file, line: line)
        } catch {
            XCTFail("Decoding of Base32 string \"\(encodedString)\" threw an unexpected error: \(error)", file: file, line: line)
        }
    }

    func testDecodeWithoutPadding() {
        assert("", decodesTo: "")
        assert("MY", decodesTo: "f")
        assert("MZXQ", decodesTo: "fo")
        assert("MZXW6", decodesTo: "foo")
        assert("MZXW6YQ", decodesTo: "foob")
        assert("MZXW6YTB", decodesTo: "fooba")
        assert("MZXW6YTBOI", decodesTo: "foobar")
    }

    func testDecodeWithOddPadding() {
        assert("=========", decodesTo: "")
        assert("MY=", decodesTo: "f")
        assert("MZXQ==", decodesTo: "fo")
        assert("MZXW6==", decodesTo: "foo")
        assert("MZXW6YQ==", decodesTo: "foob")
        assert("MZXW6YTB=", decodesTo: "fooba")
        assert("MZXW6YTBOI===", decodesTo: "foobar")
    }

    private func assert(_ encodedString: String, decodesTo asciiString: String, file: StaticString = #file, line: UInt = #line) {
        guard let expectedData = asciiString.data(using: String.Encoding.ascii) else {
            XCTFail("Could not convert ASCII string \"\(asciiString)\" to Data", file: file, line: line)
            return
        }

        let decodedData: Data
        do {
            decodedData = try Base32.decode(encodedString)
        } catch {
            XCTFail("Decoding of encoded string \"\(encodedString)\" threw an unexpected error: \(error)", file: file, line: line)
            return
        }

        XCTAssertEqual(decodedData, expectedData, "Encoded string \"\(encodedString)\" decoded to \"\(decodedData)\" (expected result: \"\(expectedData)\")", file: file, line: line)
    }

    func testIncompleteBlocks() {
        let encodedStrings = [
            "A",
            "AAA",
            "AAAAAA",
            "AAAAAAAAA",
            "AAAAAAAAAAA",
            "AAAAAAAAAAAAAA",
        ]

        for encodedString in encodedStrings {
            do {
                let decodedData = try Base32.decode(encodedString)
                XCTAssertNil(decodedData, "Unexpected decoded data: \(decodedData)")
            } catch Base32.Error.incompleteBlock {
                // This is the expected error
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testStrayBits() {
        // These are the RFC strings which end in padding, with the last non-padding character incremented by one
        let encodedStrings = [
            "MZ======",
            "MZXR====",
            "MZXW7===",
            "MZXW6YR=",
            "MZXW6YTBOJ======",
        ]

        for encodedString in encodedStrings {
            do {
                let decodedData = try Base32.decode(encodedString)
                XCTAssertNil(decodedData, "Encoded string \"\(encodedString)\" unexpectedly decoded to data: \(decodedData)")
            } catch Base32.Error.strayBits {
                // This is the expected error
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }

    }

    func testDecodeNonAlphabetCharacter() {
        do {
            // Test non-alphabet ASCII character
            let decodedResult = try Base32.decode("!Y")
            XCTAssertNil(decodedResult, "Unexpected decoded string: \(decodedResult)")
        } catch Base32.Error.nonAlphabetCharacter {
            // This is the expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        do {
            // Test non-ASCII character
            let decodedResult = try Base32.decode("🐙")
            XCTAssertNil(decodedResult, "Unexpected decoded string: \(decodedResult)")
        } catch Base32.Error.nonAlphabetCharacter {
            // This is the expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
