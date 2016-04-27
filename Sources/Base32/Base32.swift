//
//  Base32.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

import Foundation

public func base32(data: NSData) -> String {
    let byteCount = data.length / sizeof(UInt8)
    var byteArray = Array<UInt8>(repeating: 0, count: byteCount)
    data.getBytes(&byteArray, length: byteArray.count)
    return base32(bytes: byteArray)
}


private let quantumSize = 5

public func base32<S: Sequence where S.Iterator.Element == UInt8>(bytes: S) -> String {
    return stringForData(bytes: ArraySlice(bytes))
}

private func stringForData(bytes: ArraySlice<Byte>) -> String {
    var s = String()
    for quantumStart in stride(from: bytes.startIndex, to: bytes.endIndex, by: quantumSize) {
        let quantumEnd = min(quantumStart + quantumSize, bytes.endIndex)
        let q = bytes[quantumStart..<quantumEnd]
        s += stringForNextQuantum(bytes: q)
    }
    return s
}

private func stringForNextQuantum(bytes: ArraySlice<Byte>) -> String {
    switch bytes.count {
    case 0:
        return ""
    case 1:
        return stringForBytes(bytes[bytes.startIndex])
    case 2:
        return stringForBytes(bytes[bytes.startIndex],
                              bytes[bytes.startIndex + 1])
    case 3:
        return stringForBytes(bytes[bytes.startIndex],
                              bytes[bytes.startIndex + 1],
                              bytes[bytes.startIndex + 2])
    case 4:
        return stringForBytes(bytes[bytes.startIndex],
                              bytes[bytes.startIndex + 1],
                              bytes[bytes.startIndex + 2],
                              bytes[bytes.startIndex + 3])
    default:
        return stringForBytes(bytes[bytes.startIndex],
                              bytes[bytes.startIndex + 1],
                              bytes[bytes.startIndex + 2],
                              bytes[bytes.startIndex + 3],
                              bytes[bytes.startIndex + 4])
    }
}

private func stringForBytes(_ b0: Byte, _ b1: Byte, _ b2: Byte, _ b3: Byte, _ b4: Byte) -> String {
    let q = quintetsFromBytes(b0, b1, b2, b3, b4)
    let c0 = encodedValue(q.0)
    let c1 = encodedValue(q.1)
    let c2 = encodedValue(q.2)
    let c3 = encodedValue(q.3)
    let c4 = encodedValue(q.4)
    let c5 = encodedValue(q.5)
    let c6 = encodedValue(q.6)
    let c7 = encodedValue(q.7)
    return c0 + c1 + c2 + c3 + c4 + c5 + c6 + c7
}

private func stringForBytes(_ b0: Byte, _ b1: Byte, _ b2: Byte, _ b3: Byte) -> String {
    let q = quintetsFromBytes(b0, b1, b2, b3)
    let c0 = encodedValue(q.0)
    let c1 = encodedValue(q.1)
    let c2 = encodedValue(q.2)
    let c3 = encodedValue(q.3)
    let c4 = encodedValue(q.4)
    let c5 = encodedValue(q.5)
    let c6 = encodedValue(q.6)
    let c7 = paddingCharacter
    return c0 + c1 + c2 + c3 + c4 + c5 + c6 + c7
}

private func stringForBytes(_ b0: Byte, _ b1: Byte, _ b2: Byte) -> String {
    let q = quintetsFromBytes(b0, b1, b2)
    let c0 = encodedValue(q.0)
    let c1 = encodedValue(q.1)
    let c2 = encodedValue(q.2)
    let c3 = encodedValue(q.3)
    let c4 = encodedValue(q.4)
    let c5 = paddingCharacter
    let c6 = paddingCharacter
    let c7 = paddingCharacter
    return c0 + c1 + c2 + c3 + c4 + c5 + c6 + c7
}

private func stringForBytes(_ b0: Byte, _ b1: Byte) -> String {
    let q = quintetsFromBytes(b0, b1)
    let c0 = encodedValue(q.0)
    let c1 = encodedValue(q.1)
    let c2 = encodedValue(q.2)
    let c3 = encodedValue(q.3)
    let c4 = paddingCharacter
    let c5 = paddingCharacter
    let c6 = paddingCharacter
    let c7 = paddingCharacter
    return c0 + c1 + c2 + c3 + c4 + c5 + c6 + c7
}

private func stringForBytes(_ b0: Byte) -> String {
    let q = quintetsFromBytes(b0)
    let c0 = encodedValue(q.0)
    let c1 = encodedValue(q.1)
    let c2 = paddingCharacter
    let c3 = paddingCharacter
    let c4 = paddingCharacter
    let c5 = paddingCharacter
    let c6 = paddingCharacter
    let c7 = paddingCharacter
    return c0 + c1 + c2 + c3 + c4 + c5 + c6 + c7
}
