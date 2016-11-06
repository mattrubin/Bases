//
//  Base32.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

import Foundation

public enum Base32 {
    /// The size of a block before encoding, measured in bytes.
    private static let unencodedBlockSize = 5
    /// The size of a block after encoding, measured in bytes.
    private static let encodedBlockSize = 8

    public static func encode(_ data: Data) -> String {
        let unencodedLength = data.count

        let encodedLength = Base32.encodedLength(unencodedLength: unencodedLength)
        let encodedBytes = UnsafeMutablePointer<EncodedChar>.allocate(capacity: encodedLength)

        data.withUnsafeBytes { (unencodedBytes: UnsafePointer<Byte>) in
        var encodedWriteOffset = 0
        for unencodedReadOffset in stride(from: 0, to: unencodedLength, by: unencodedBlockSize) {
            let nextBlockBytes = unencodedBytes + unencodedReadOffset
            let nextBlockSize = min(unencodedBlockSize, unencodedLength - unencodedReadOffset)

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

        // The NSData object takes ownership of the allocated bytes and will handle deallocation.
        let encodedData = Data(bytesNoCopy: encodedBytes, count: encodedLength, deallocator: .free)
        let encodedString = String(data: encodedData, encoding: .ascii)!
        return encodedString
    }

    private static func encodedLength(unencodedLength: Int) -> Int {
        let fullBlockCount = unencodedLength / unencodedBlockSize
        let remainingRawBytes = unencodedLength % unencodedBlockSize
        let blockCount = remainingRawBytes > 0 ? fullBlockCount + 1 : fullBlockCount
        return blockCount * encodedBlockSize
    }
}
