//
//  Base32.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

private let quantumSize = 5

public func encode(bytes: ArraySlice<UInt8>) -> String? {
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
    // Special processing is performed if fewer than 40 bits are available
    // at the end of the data being encoded.  A full encoding quantum is
    // always completed at the end of a body.  When fewer than 40 input bits
    // are available in an input group, bits with value zero are added (on
    // the right) to form an integral number of 5-bit groups.  Padding at
    // the end of the data is performed using the "=" character.  Since all
    // base 32 input is an integral number of octets, only the following
    // cases can arise:
    switch bytes.count {
    case 0:
        return ""
    case 1:
        // The final quantum of encoding input is exactly 8 bits; here, the
        // final unit of encoded output will be two characters followed by
        // six "=" padding characters.
        let q = quintets(bytes[0])
        if let
            c0 = characterForValue(q.0),
            c1 = characterForValue(q.1)
        {
            return String([c0, c1, "=", "=", "=", "=", "=", "="])
        }
    case 2:
        // The final quantum of encoding input is exactly 16 bits; here, the
        // final unit of encoded output will be four characters followed by
        // four "=" padding characters.
        let q = quintets(bytes[0], bytes[1])
        if let
            c0 = characterForValue(q.0),
            c1 = characterForValue(q.1),
            c2 = characterForValue(q.2),
            c3 = characterForValue(q.3)
        {
            return String([c0, c1, c2, c3, "=", "=", "=", "="])
        }
    case 3:
        // The final quantum of encoding input is exactly 24 bits; here, the
        // final unit of encoded output will be five characters followed by
        // three "=" padding characters.
        let q = quintets(bytes[0], bytes[1], bytes[2])
        if let
            c0 = characterForValue(q.0),
            c1 = characterForValue(q.1),
            c2 = characterForValue(q.2),
            c3 = characterForValue(q.3),
            c4 = characterForValue(q.4)
        {
            return String([c0, c1, c2, c3, c4, "=", "=", "="])
        }
    case 4:
        // The final quantum of encoding input is exactly 32 bits; here, the
        // final unit of encoded output will be seven characters followed by
        // one "=" padding character.
        let q = quintets(bytes[0], bytes[1], bytes[2], bytes[3])
        if let
            c0 = characterForValue(q.0),
            c1 = characterForValue(q.1),
            c2 = characterForValue(q.2),
            c3 = characterForValue(q.3),
            c4 = characterForValue(q.4),
            c5 = characterForValue(q.5),
            c6 = characterForValue(q.6)
        {
            return String([c0, c1, c2, c3, c4, c5, c6, "="])
        }
    default:
        // The final quantum of encoding input is an integral multiple of 40
        // bits; here, the final unit of encoded output will be an integral
        // multiple of 8 characters with no "=" padding.
        let q = quintets(bytes[0], bytes[1], bytes[2], bytes[3], bytes[4])
        if let
            c0 = characterForValue(q.0),
            c1 = characterForValue(q.1),
            c2 = characterForValue(q.2),
            c3 = characterForValue(q.3),
            c4 = characterForValue(q.4),
            c5 = characterForValue(q.5),
            c6 = characterForValue(q.6),
            c7 = characterForValue(q.7)
        {
            return String([c0, c1, c2, c3, c4, c5, c6, c7])
        }
    }

    // Something failed
    return nil
}
