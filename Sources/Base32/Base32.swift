//
//  Base32.swift
//  Bases
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

import Foundation

public enum Base32 {
    /// The size of a block before encoding, measured in bytes.
    private static let unencodedBlockSize = 5
    /// The size of a block after encoding, measured in bytes.
    private static let encodedBlockSize = 8

    public static func encode(_ data: Data) -> String {
        let unencodedByteCount = data.count

        let encodedByteCount = byteCount(encoding: unencodedByteCount)
        let encodedBytes = UnsafeMutablePointer<EncodedChar>.allocate(capacity: encodedByteCount)

        data.withUnsafeBytes { (unencodedBytes: UnsafePointer<Byte>) in
            var encodedWriteOffset = 0
            for unencodedReadOffset in stride(from: 0, to: unencodedByteCount, by: unencodedBlockSize) {
                let nextBlockBytes = unencodedBytes + unencodedReadOffset
                let nextBlockSize = min(unencodedBlockSize, unencodedByteCount - unencodedReadOffset)

                let nextChars = encodeBlock(bytes: nextBlockBytes, size: nextBlockSize)
                encodedBytes[encodedWriteOffset + 0] = nextChars.0
                encodedBytes[encodedWriteOffset + 1] = nextChars.1
                encodedBytes[encodedWriteOffset + 2] = nextChars.2
                encodedBytes[encodedWriteOffset + 3] = nextChars.3
                encodedBytes[encodedWriteOffset + 4] = nextChars.4
                encodedBytes[encodedWriteOffset + 5] = nextChars.5
                encodedBytes[encodedWriteOffset + 6] = nextChars.6
                encodedBytes[encodedWriteOffset + 7] = nextChars.7

                encodedWriteOffset += encodedBlockSize
            }
        }

        // The Data instance takes ownership of the allocated bytes and will handle deallocation.
        let encodedData = Data(bytesNoCopy: encodedBytes,
                               count: encodedByteCount,
                               deallocator: .free)
        guard let encodedString = String(data: encodedData, encoding: .ascii) else {
            fatalError("Internal Error: Encoded data could not be encoded as ASCII (\(encodedData))")
        }
        return encodedString
    }

    private static func byteCount(encoding unencodedByteCount: Int) -> Int {
        let fullBlockCount = unencodedByteCount / unencodedBlockSize
        let remainingRawBytes = unencodedByteCount % unencodedBlockSize
        let blockCount = remainingRawBytes > 0 ? fullBlockCount + 1 : fullBlockCount
        return blockCount * encodedBlockSize
    }

    public static func decode(_ string: String) throws -> Data {
        guard let encodedData = string.data(using: String.Encoding.ascii) else {
            throw Error.nonAlphabetCharacter
        }
        let encodedByteCount = nonPaddingByteCount(encodedData: encodedData)

        let decodedByteCount = try byteCount(decoding: encodedByteCount)
        let decodedBytes = UnsafeMutablePointer<Byte>.allocate(capacity: decodedByteCount)

        try encodedData.withUnsafeBytes { (encodedChars: UnsafePointer<EncodedChar>) in
            var decodedWriteOffset = 0
            for encodedReadOffset in stride(from: 0, to: encodedByteCount, by: encodedBlockSize) {
                let chars = encodedChars + encodedReadOffset

                switch min(encodedByteCount - encodedReadOffset, encodedBlockSize) {
                case 2:
                    let byte = try decodeBlock(chars[0], chars[1])
                    decodedBytes[decodedWriteOffset + 0] = byte
                case 4:
                    let bytes = try decodeBlock(chars[0], chars[1], chars[2], chars[3])
                    decodedBytes[decodedWriteOffset + 0] = bytes.0
                    decodedBytes[decodedWriteOffset + 1] = bytes.1
                case 5:
                    let bytes = try decodeBlock(chars[0], chars[1], chars[2], chars[3], chars[4])
                    decodedBytes[decodedWriteOffset + 0] = bytes.0
                    decodedBytes[decodedWriteOffset + 1] = bytes.1
                    decodedBytes[decodedWriteOffset + 2] = bytes.2
                case 7:
                    let bytes = try decodeBlock(chars[0], chars[1], chars[2], chars[3], chars[4], chars[5], chars[6])
                    decodedBytes[decodedWriteOffset + 0] = bytes.0
                    decodedBytes[decodedWriteOffset + 1] = bytes.1
                    decodedBytes[decodedWriteOffset + 2] = bytes.2
                    decodedBytes[decodedWriteOffset + 3] = bytes.3
                case 8:
                    let bytes =
                        try decodeBlock(chars[0], chars[1], chars[2], chars[3], chars[4], chars[5], chars[6], chars[7])
                    decodedBytes[decodedWriteOffset + 0] = bytes.0
                    decodedBytes[decodedWriteOffset + 1] = bytes.1
                    decodedBytes[decodedWriteOffset + 2] = bytes.2
                    decodedBytes[decodedWriteOffset + 3] = bytes.3
                    decodedBytes[decodedWriteOffset + 4] = bytes.4
                default:
                    throw Base32.Error.incompleteBlock
                }

                decodedWriteOffset += unencodedBlockSize
            }
        }

        // The Data instance takes ownership of the allocated bytes and will handle deallocation.
        return Data(bytesNoCopy: decodedBytes, count: decodedByteCount, deallocator: .free)
    }

    private static func nonPaddingByteCount(encodedData: Data) -> Int {
        if let lastNonPaddingCharacterIndex = encodedData.lastIndex(where: { $0 != paddingCharacter }) {
            return lastNonPaddingCharacterIndex + 1
        }
        return 0
    }

    private static func byteCount(decoding encodedByteCount: Int) throws -> Int {
        let extraEncodedBytes = encodedByteCount % encodedBlockSize
        let extraDecodedBytes: Int
        switch extraEncodedBytes {
        case 0:
            extraDecodedBytes = 0
        case 2:
            extraDecodedBytes = 1
        case 4:
            extraDecodedBytes = 2
        case 5:
            extraDecodedBytes = 3
        case 7:
            extraDecodedBytes = 4
        default:
            throw Error.incompleteBlock
        }
        return (encodedByteCount / encodedBlockSize) * unencodedBlockSize + extraDecodedBytes
    }

    public enum Error: Swift.Error {
        /// The input string ends with an incomplete encoded block
        case incompleteBlock
        /// The input string contains a character not in the encoding alphabet
        case nonAlphabetCharacter
        /// The last encoded character has non-zero padding bits
        /// https://tools.ietf.org/html/rfc4648#section-3.5
        case strayBits
    }
}
