//
//  Base32.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

private let quantumSize = 5

public func base32<S: SequenceType where S.Generator.Element == UInt8>(bytes: S) -> String {
    return stringForData(ArraySlice(bytes))
}

private func stringForData(bytes: ArraySlice<Byte>) -> String {
    let s = stringForNextQuantum(bytes)
    if bytes.count <= quantumSize {
        return s
    } else {
        // There's more data to encode
        let remainingBytes = bytes[(bytes.startIndex + quantumSize)..<(bytes.endIndex)]
        return s + stringForData(remainingBytes)
    }
}

private func stringForNextQuantum(bytes: ArraySlice<Byte>) -> String {
    switch bytes.count {
    case 0:
        return ""
    case 1:
        return stringForBytes(bytes[0], nil, nil, nil, nil)
    case 2:
        return stringForBytes(bytes[0], bytes[1], nil, nil, nil)
    case 3:
        return stringForBytes(bytes[0], bytes[1], bytes[2], nil, nil)
    case 4:
        return stringForBytes(bytes[0], bytes[1], bytes[2], bytes[3], nil)
    default:
        return stringForBytes(bytes[0], bytes[1], bytes[2], bytes[3], bytes[4])
    }
}

private func stringForBytes(b0: Byte, b1: Byte?, b2: Byte?, b3: Byte?, b4: Byte?) -> String
{
    let q = quintetsFromBytes(b0, b1, b2, b3, b4)
    let c0 = characterForValue(q.0)
    let c1 = characterForValue(q.1)
    let c2 = characterOrPaddingForValue(q.2)
    let c3 = characterOrPaddingForValue(q.3)
    let c4 = characterOrPaddingForValue(q.4)
    let c5 = characterOrPaddingForValue(q.5)
    let c6 = characterOrPaddingForValue(q.6)
    let c7 = characterOrPaddingForValue(q.7)
    return String([c0, c1, c2, c3, c4, c5, c6, c7])
}
