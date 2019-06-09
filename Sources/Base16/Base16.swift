//
//  Base16.swift
//  Bases
//
//  Copyright (c) 2016-2019 Matt Rubin and the Bases authors
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

import Foundation

public enum Base16 {
    /// The size of a block before encoding, measured in bytes.
    private static let unencodedBlockSize = 1
    /// The size of a block after encoding, measured in bytes.
    private static let encodedBlockSize = 2

    public static func encode(_ data: Data) -> String {
        let unencodedByteCount = data.count

        let encodedByteCount = unencodedByteCount * encodedBlockSize
        let encodedBytes = UnsafeMutablePointer<EncodedChar>.allocate(capacity: encodedByteCount)

        data.withUnsafeBytes { unencodedBytes in
            var encodedWriteOffset = 0
            for unencodedReadOffset in stride(from: 0, to: unencodedByteCount, by: unencodedBlockSize) {
                let nextUnencodedByte = unencodedBytes[unencodedReadOffset]

                let bigNibble = (nextUnencodedByte & 0b11110000) >> 4
                let littleNibble = nextUnencodedByte & 0b00001111
                let bigChar = encodingTable[Int(bigNibble)]
                let littleChar = encodingTable[Int(littleNibble)]
                encodedBytes[encodedWriteOffset + 0] = bigChar
                encodedBytes[encodedWriteOffset + 1] = littleChar

                encodedWriteOffset += encodedBlockSize
            }
        }

        // The Data instance takes ownership of the allocated bytes and will handle deallocation.
        let encodedData = Data(bytesNoCopy: encodedBytes,
                               count: encodedByteCount,
                               deallocator: .free)
        guard let encodedString = String(data: encodedData, encoding: String.Encoding.ascii) else {
            fatalError("Internal Error: Encoded data could not be encoded as ASCII (\(encodedData))")
        }
        return encodedString
    }

    public static func decode(_ string: String) throws -> Data {
        guard let encodedData = string.data(using: String.Encoding.ascii) else {
            throw Error.nonAlphabetCharacter
        }
        let encodedByteCount = encodedData.count

        let decodedByteCount = try byteCount(decoding: encodedByteCount)
        let decodedBytes = UnsafeMutablePointer<Byte>.allocate(capacity: decodedByteCount)

        try encodedData.withUnsafeBytes { encodedBytes in
            var decodedWriteOffset = 0
            for encodedReadOffset in stride(from: 0, to: encodedByteCount, by: encodedBlockSize) {
                let bigChar = encodedBytes[encodedReadOffset]
                let littleChar = encodedBytes[encodedReadOffset + 1]

                let bigNibble = try byte(decoding: bigChar)
                let littleNibble = try byte(decoding: littleChar)

                let decodedByte = ((bigNibble & 0b00001111) << 4) | (littleNibble & 0b00001111)
                decodedBytes[decodedWriteOffset] = decodedByte

                decodedWriteOffset += unencodedBlockSize
            }
        }

        // The Data instance takes ownership of the allocated bytes and will handle deallocation.
        return Data(bytesNoCopy: decodedBytes, count: decodedByteCount, deallocator: .free)
    }

    private static func byteCount(decoding encodedByteCount: Int) throws -> Int {
        guard encodedByteCount % encodedBlockSize == 0 else {
            throw Error.incompleteBlock
        }
        return (encodedByteCount / encodedBlockSize) * unencodedBlockSize
    }

    public enum Error: Swift.Error {
        /// The input string ends with an incomplete encoded block
        case incompleteBlock
        /// The input string contains a character not in the encoding alphabet 
        case nonAlphabetCharacter
    }
}
