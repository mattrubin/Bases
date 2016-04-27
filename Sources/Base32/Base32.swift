//
//  Base32.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

import Foundation

private let quantumSize = 5

public func base32(data: NSData) -> String {
    let bytes = UnsafePointer<Byte>(data.bytes)
    let length = data.length / sizeof(UInt8)

    var s = Array<CUnsignedChar>()
    for quantumStart in stride(from: 0, to: length, by: quantumSize) {
        let quantumEnd = min(quantumStart + quantumSize, length)
        let byteGroup = bytes + quantumStart
        let byteCount = quantumEnd - quantumStart

        let nextChars = stringForNextQuantum(bytes: byteGroup, count: byteCount)
        s.append(nextChars.0)
        s.append(nextChars.1)
        s.append(nextChars.2)
        s.append(nextChars.3)
        s.append(nextChars.4)
        s.append(nextChars.5)
        s.append(nextChars.6)
        s.append(nextChars.7)
    }
    let encodedBytes = UnsafeMutablePointer<CUnsignedChar>(allocatingCapacity: s.count)
    encodedBytes.initializeFrom(s)
    // The NSData object takes ownership of the allocated bytes and will handle deallocation.
    let encodedData = NSData(bytesNoCopy: encodedBytes, length: s.count)
    let encodedString = String(data: encodedData, encoding: NSASCIIStringEncoding)!
    return encodedString
}

typealias EncodedBlock = (CUnsignedChar, CUnsignedChar, CUnsignedChar, CUnsignedChar,
    CUnsignedChar, CUnsignedChar, CUnsignedChar, CUnsignedChar)

private func stringForNextQuantum(bytes: UnsafePointer<Byte>, count: Int) -> EncodedBlock {
    switch count {
    case 0:
        fatalError()
    case 1:
        return encodeBytes(bytes[0])
    case 2:
        return encodeBytes(bytes[0], bytes[1])
    case 3:
        return encodeBytes(bytes[0], bytes[1], bytes[2])
    case 4:
        return encodeBytes(bytes[0], bytes[1], bytes[2], bytes[3])
    default:
        return encodeBytes(bytes[0], bytes[1], bytes[2], bytes[3], bytes[4])
    }
}

private func encodeBytes(_ b0: Byte, _ b1: Byte, _ b2: Byte, _ b3: Byte, _ b4: Byte) -> EncodedBlock {
    let q = quintetsFromBytes(b0, b1, b2, b3, b4)
    let c0 = encodedValue(q.0)
    let c1 = encodedValue(q.1)
    let c2 = encodedValue(q.2)
    let c3 = encodedValue(q.3)
    let c4 = encodedValue(q.4)
    let c5 = encodedValue(q.5)
    let c6 = encodedValue(q.6)
    let c7 = encodedValue(q.7)
    return (c0, c1, c2, c3, c4, c5, c6, c7)
}

private func encodeBytes(_ b0: Byte, _ b1: Byte, _ b2: Byte, _ b3: Byte) -> EncodedBlock {
    let q = quintetsFromBytes(b0, b1, b2, b3)
    let c0 = encodedValue(q.0)
    let c1 = encodedValue(q.1)
    let c2 = encodedValue(q.2)
    let c3 = encodedValue(q.3)
    let c4 = encodedValue(q.4)
    let c5 = encodedValue(q.5)
    let c6 = encodedValue(q.6)
    let c7 = paddingCharacter
    return (c0, c1, c2, c3, c4, c5, c6, c7)
}

private func encodeBytes(_ b0: Byte, _ b1: Byte, _ b2: Byte) -> EncodedBlock {
    let q = quintetsFromBytes(b0, b1, b2)
    let c0 = encodedValue(q.0)
    let c1 = encodedValue(q.1)
    let c2 = encodedValue(q.2)
    let c3 = encodedValue(q.3)
    let c4 = encodedValue(q.4)
    let c5 = paddingCharacter
    let c6 = paddingCharacter
    let c7 = paddingCharacter
    return (c0, c1, c2, c3, c4, c5, c6, c7)
}

private func encodeBytes(_ b0: Byte, _ b1: Byte) -> EncodedBlock {
    let q = quintetsFromBytes(b0, b1)
    let c0 = encodedValue(q.0)
    let c1 = encodedValue(q.1)
    let c2 = encodedValue(q.2)
    let c3 = encodedValue(q.3)
    let c4 = paddingCharacter
    let c5 = paddingCharacter
    let c6 = paddingCharacter
    let c7 = paddingCharacter
    return (c0, c1, c2, c3, c4, c5, c6, c7)
}

private func encodeBytes(_ b0: Byte) -> EncodedBlock {
    let q = quintetsFromBytes(b0)
    let c0 = encodedValue(q.0)
    let c1 = encodedValue(q.1)
    let c2 = paddingCharacter
    let c3 = paddingCharacter
    let c4 = paddingCharacter
    let c5 = paddingCharacter
    let c6 = paddingCharacter
    let c7 = paddingCharacter
    return (c0, c1, c2, c3, c4, c5, c6, c7)
}
