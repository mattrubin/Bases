//
//  Base16Tests.swift
//  Base16Tests
//
//  Copyright (c) 2016 Matt Rubin and the Bases authors
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
import Base16

class Base16Tests: XCTestCase {
    func testRFC() {
        let rfcTestVectors = [
            ("", ""),
            ("f", "66"),
            ("fo", "666F"),
            ("foo", "666F6F"),
            ("foob", "666F6F62"),
            ("fooba", "666F6F6261"),
            ("foobar", "666F6F626172"),
        ]

        for (decodedString, encodedString) in rfcTestVectors {
            guard let decodedData = decodedString.data(using: String.Encoding.ascii) else {
                XCTFail("Could not convert ASCII string \"\(decodedString)\" to Data")
                continue
            }

            let encodedResult = Base16.encode(decodedData)
            XCTAssertEqual(encodedResult, encodedString, "ASCII string \"\(decodedString)\" encoded to \"\(encodedResult)\" (expected \"\(encodedString)\")")

            do {
                let decodedResult = try Base16.decode(encodedString)
                XCTAssertEqual(decodedResult, decodedData, "Encoded string \"\(encodedString)\" decoded to data \"\(decodedResult)\" (expected \"\(decodedData)\")")
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testDecodeNonAlphabetCharacter() {
        do {
            // Test non-alphabet character in the first half of a block
            let decodedResult = try Base16.decode("QA")
            XCTAssertNil(decodedResult, "Unexpected decoded string: \(decodedResult)")
        } catch Base16.Error.nonAlphabetCharacter {
            // This is the expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        do {
            // Test non-alphabet character in the second half of a block
            let decodedResult = try Base16.decode("AQ")
            XCTAssertNil(decodedResult, "Unexpected decoded string: \(decodedResult)")
        } catch Base16.Error.nonAlphabetCharacter {
            // This is the expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        do {
            // Test non-ASCII character
            let decodedResult = try Base16.decode("🐙")
            XCTAssertNil(decodedResult, "Unexpected decoded string: \(decodedResult)")
        } catch Base16.Error.nonAlphabetCharacter {
            // This is the expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testDecodePartialBlock() {
        do {
            // Test partial encoded block
            let decodedPartial = try Base16.decode("6")
            XCTAssertNil(decodedPartial, "Unexpected decoded string: \(decodedPartial)")
        } catch Base16.Error.incompleteBlock {
            // This is the expected error
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        do {
            // Test full encoded block
            let decodedFull = try Base16.decode("66")
            XCTAssertEqual(decodedFull, Data(bytes: [102]), "Unexpected decoded string: \(decodedFull)")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testFullAlphabet() {
        let fullAlphabetUppercaseString = "0123456789ABCDEF"
        do {
            let decodedData = try Base16.decode(fullAlphabetUppercaseString)
            let encodedString = Base16.encode(decodedData)
            XCTAssertEqual(encodedString, fullAlphabetUppercaseString)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        let fullAlphabetLowercaseString = "0123456789abcdef"
        do {
            let decodedData = try Base16.decode(fullAlphabetLowercaseString)
            let encodedString = Base16.encode(decodedData)
            XCTAssertEqual(encodedString, fullAlphabetUppercaseString)
            XCTAssertEqual(encodedString.lowercased(), fullAlphabetLowercaseString)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
