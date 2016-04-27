//
//  BlockEncoding.swift
//  Bases
//
//  Created by Matt Rubin on 4/27/16.
//  Copyright © 2016 Matt Rubin. All rights reserved.
//

internal typealias EncodedBlock = (CUnsignedChar, CUnsignedChar, CUnsignedChar, CUnsignedChar,
    CUnsignedChar, CUnsignedChar, CUnsignedChar, CUnsignedChar)

internal func encodeBlock(bytes: UnsafePointer<Byte>, size: Int) -> EncodedBlock {
    switch size {
    case 0:
        fatalError()
    case 1:
        return encodeBlock(bytes[0])
    case 2:
        return encodeBlock(bytes[0], bytes[1])
    case 3:
        return encodeBlock(bytes[0], bytes[1], bytes[2])
    case 4:
        return encodeBlock(bytes[0], bytes[1], bytes[2], bytes[3])
    default:
        return encodeBlock(bytes[0], bytes[1], bytes[2], bytes[3], bytes[4])
    }
}

private func encodeBlock(_ b0: Byte, _ b1: Byte, _ b2: Byte, _ b3: Byte, _ b4: Byte) -> EncodedBlock {
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

private func encodeBlock(_ b0: Byte, _ b1: Byte, _ b2: Byte, _ b3: Byte) -> EncodedBlock {
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

private func encodeBlock(_ b0: Byte, _ b1: Byte, _ b2: Byte) -> EncodedBlock {
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

private func encodeBlock(_ b0: Byte, _ b1: Byte) -> EncodedBlock {
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

private func encodeBlock(_ b0: Byte) -> EncodedBlock {
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
