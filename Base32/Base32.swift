//
//  Base32.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

private let quantumSize = 5

public func base32<S: SequenceType where S.Generator.Element == UInt8>(bytes: S) -> String? {
    return encode(ArraySlice(bytes))
}

private func encode(bytes: ArraySlice<UInt8>) -> String? {
    if let s = encodeQuantum(bytes) {
        if bytes.count <= quantumSize {
            return s
        } else {
            // There's more data to encode
            let remainingBytes = bytes[(bytes.startIndex + quantumSize)..<(bytes.endIndex)]
            if let restOfString = encode(remainingBytes) {
                return s + restOfString
            }
        }
    }

    // Something failed
    return nil
}

private func encodeQuantum(bytes: ArraySlice<UInt8>) -> String? {
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


private func stringForBytes(b0: UInt8, b1: UInt8?, b2: UInt8?, b3: UInt8?, b4: UInt8?)
    -> String?
{
    let q = quintetsFromBytes(b0, b1, b2, b3, b4)
    if let
        c0 = characterForValue(q.0),
        c1 = characterForValue(q.1),
        c2 = characterOrPaddingForValue(q.2),
        c3 = characterOrPaddingForValue(q.3),
        c4 = characterOrPaddingForValue(q.4),
        c5 = characterOrPaddingForValue(q.5),
        c6 = characterOrPaddingForValue(q.6),
        c7 = characterOrPaddingForValue(q.7)
    {
        return String([c0, c1, c2, c3, c4, c5, c6, c7])
    } else {
        return nil
    }
}

private func characterOrPaddingForValue(value: UInt8?) -> Character? {
    if let value = value {
        return characterForValue(value)
    } else {
        return pad
    }
}
