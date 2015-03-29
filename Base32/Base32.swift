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
    switch bytes.count {
    case 0:
        return ""
    case 1:
        let q = quintets(bytes[0])
        if let c = charactersForQuintets(q) {
            return String([c.0, c.1, "=", "=", "=", "=", "=", "="])
        }
    case 2:
        let q = quintets(bytes[0], bytes[1])
        if let c = charactersForQuintets(q) {
            return String([c.0, c.1, c.2, c.3, "=", "=", "=", "="])
        }
    case 3:
        let q = quintets(bytes[0], bytes[1], bytes[2])
        if let c = charactersForQuintets(q) {
            return String([c.0, c.1, c.2, c.3, c.4, "=", "=", "="])
        }
    case 4:
        let q = quintets(bytes[0], bytes[1], bytes[2], bytes[3])
        if let c = charactersForQuintets(q) {
            return String([c.0, c.1, c.2, c.3, c.4, c.5, c.6, "="])
        }
    default:
        let q = quintets(bytes[0], bytes[1], bytes[2], bytes[3], bytes[4])
        if let c = charactersForQuintets(q) {
            return String([c.0, c.1, c.2, c.3, c.4, c.5, c.6, c.7])
        }
    }
    // Something failed
    return nil
}


// MARK: Quintets -> Characters

private func charactersForQuintets(q0: UInt8, q1: UInt8) -> (Character, Character)?
{
    if let
        c0 = characterForValue(q0),
        c1 = characterForValue(q1)
    {
        return (c0, c1)
    } else {
        return nil
    }
}

private func charactersForQuintets(q0: UInt8, q1: UInt8, q2: UInt8, q3: UInt8)
    -> (Character, Character, Character, Character)?
{
    if let
        c0 = characterForValue(q0),
        c1 = characterForValue(q1),
        c2 = characterForValue(q2),
        c3 = characterForValue(q3)
    {
        return (c0, c1, c2, c3)
    } else {
        return nil
    }
}

private func charactersForQuintets(q0: UInt8, q1: UInt8, q2: UInt8, q3: UInt8, q4: UInt8)
    -> (Character, Character, Character, Character, Character)?
{
    if let
        c0 = characterForValue(q0),
        c1 = characterForValue(q1),
        c2 = characterForValue(q2),
        c3 = characterForValue(q3),
        c4 = characterForValue(q4)
    {
        return (c0, c1, c2, c3, c4)
    } else {
        return nil
    }
}

private func charactersForQuintets(q0: UInt8, q1: UInt8, q2: UInt8, q3: UInt8, q4: UInt8, q5: UInt8, q6: UInt8)
    -> (Character, Character, Character, Character, Character, Character, Character)?
{
    if let
        c0 = characterForValue(q0),
        c1 = characterForValue(q1),
        c2 = characterForValue(q2),
        c3 = characterForValue(q3),
        c4 = characterForValue(q4),
        c5 = characterForValue(q5),
        c6 = characterForValue(q6)
    {
        return (c0, c1, c2, c3, c4, c5, c6)
    } else {
        return nil
    }
}

private func charactersForQuintets(q0: UInt8, q1: UInt8, q2: UInt8, q3: UInt8, q4: UInt8, q5: UInt8, q6: UInt8, q7: UInt8)
    -> (Character, Character, Character, Character, Character, Character, Character, Character)?
{
    if let
        c0 = characterForValue(q0),
        c1 = characterForValue(q1),
        c2 = characterForValue(q2),
        c3 = characterForValue(q3),
        c4 = characterForValue(q4),
        c5 = characterForValue(q5),
        c6 = characterForValue(q6),
        c7 = characterForValue(q7)
    {
        return (c0, c1, c2, c3, c4, c5, c6, c7)
    } else {
        return nil
    }
}
