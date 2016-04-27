//
//  Base32.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

import Foundation

private let unencodedBlockSize = 5
private let encodedBlockSize = 8

public func base32(data: NSData) -> String {
    let unencodedLength = data.length
    let unencodedBytes = UnsafePointer<Byte>(data.bytes)

    let encodedLength = Base32.encodedLength(unencodedLength: unencodedLength)
    let encodedBytes = UnsafeMutablePointer<EncodedChar>(allocatingCapacity: encodedLength)

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

    // The NSData object takes ownership of the allocated bytes and will handle deallocation.
    let encodedData = NSData(bytesNoCopy: encodedBytes, length: encodedLength)
    let encodedString = String(data: encodedData, encoding: NSASCIIStringEncoding)!
    return encodedString
}

private func encodedLength(unencodedLength: Int) -> Int {
    let fullBlockCount = unencodedLength / unencodedBlockSize
    let remainingRawBytes = unencodedLength % unencodedBlockSize
    let blockCount = remainingRawBytes > 0 ? fullBlockCount + 1 : fullBlockCount
    return blockCount * encodedBlockSize
}
