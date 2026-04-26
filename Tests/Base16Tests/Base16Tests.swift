// SPDX-FileCopyrightText: © 2016-2026 Matt Rubin and the Bases authors
// SPDX-License-Identifier: MIT

import Base16
import Foundation
import Testing

struct Base16Tests {
    @Test
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
                Issue.record("Could not convert ASCII string \"\(decodedString)\" to Data")
                continue
            }

            let encodedResult = Base16.encode(decodedData)
            #expect(
                encodedResult == encodedString,
                "ASCII string \"\(decodedString)\" encoded to \"\(encodedResult)\" (expected \"\(encodedString)\")"
            )

            do {
                let decodedResult = try Base16.decode(encodedString)
                #expect(
                    decodedResult == decodedData,
                    "Encoded string \"\(encodedString)\" decoded to data \"\(decodedResult)\" (expected \"\(decodedData)\")"
                )
            } catch {
                Issue.record("Unexpected error: \(error)")
            }
        }
    }

    @Test
    func testDecodeNonAlphabetCharacter() {
        do {
            // Test non-alphabet character in the first half of a block
            let decodedResult = try Base16.decode("QA")
            Issue.record("Unexpected decoded string: \(decodedResult)")
        } catch Base16.Error.nonAlphabetCharacter {
            // This is the expected error
        } catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            // Test non-alphabet character in the second half of a block
            let decodedResult = try Base16.decode("AQ")
            Issue.record("Unexpected decoded string: \(decodedResult)")
        } catch Base16.Error.nonAlphabetCharacter {
            // This is the expected error
        } catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            // Test non-ASCII character
            let decodedResult = try Base16.decode("🐙")
            Issue.record("Unexpected decoded string: \(decodedResult)")
        } catch Base16.Error.nonAlphabetCharacter {
            // This is the expected error
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func testDecodePartialBlock() {
        do {
            // Test partial encoded block
            let decodedPartial = try Base16.decode("6")
            Issue.record("Unexpected decoded string: \(decodedPartial)")
        } catch Base16.Error.incompleteBlock {
            // This is the expected error
        } catch {
            Issue.record("Unexpected error: \(error)")
        }

        do {
            // Test full encoded block
            let decodedFull = try Base16.decode("66")
            #expect(decodedFull == Data([102]), "Unexpected decoded string: \(decodedFull)")
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func testFullAlphabet() {
        let fullAlphabetUppercaseString = "0123456789ABCDEF"
        do {
            let decodedData = try Base16.decode(fullAlphabetUppercaseString)
            let encodedString = Base16.encode(decodedData)
            #expect(encodedString == fullAlphabetUppercaseString)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }

        let fullAlphabetLowercaseString = "0123456789abcdef"
        do {
            let decodedData = try Base16.decode(fullAlphabetLowercaseString)
            let encodedString = Base16.encode(decodedData)
            #expect(encodedString == fullAlphabetUppercaseString)
            #expect(encodedString.lowercased() == fullAlphabetLowercaseString)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}
