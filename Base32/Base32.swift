//
//  Base32.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//


public func encode(bytes: ArraySlice<UInt8>) -> String? {
    switch bytes.count {
    case 0:
        return ""
    case 1:
        let q = quintets(bytes[0], 0, 0, 0, 0)
        if let c = charactersForQuintets(q) {
            return String([c.0, c.1, "=", "=", "=", "=", "=", "="])
        }
    case 2:
        let q = quintets(bytes[0], bytes[1], 0, 0, 0)
        if let c = charactersForQuintets(q) {
            return String([c.0, c.1, c.2, c.3, "=", "=", "=", "="])
        }
    case 3:
        let q = quintets(bytes[0], bytes[1], bytes[2], 0, 0)
        if let c = charactersForQuintets(q) {
            return String([c.0, c.1, c.2, c.3, c.4, "=", "=", "="])
        }
    case 4:
        let q = quintets(bytes[0], bytes[1], bytes[2], bytes[3], 0)
        if let c = charactersForQuintets(q) {
            return String([c.0, c.1, c.2, c.3, c.4, c.5, c.6, "="])
        }
    default:
        let q = quintets(bytes[0], bytes[1], bytes[2], bytes[3], bytes[4])
        if let c = charactersForQuintets(q) {
            let s = String([c.0, c.1, c.2, c.3, c.4, c.5, c.6, c.7])
            let remainingBytes = bytes[(bytes.startIndex + 5)..<(bytes.endIndex)]
            if let restOfString = encode(remainingBytes) {
                return s + restOfString
            }
        }
    }
    // Something failed
    return nil
}

private func quintets(b0: UInt8, b1: UInt8, b2: UInt8, b3: UInt8, b4: UInt8)
    -> (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
{
    let q0 = ((b0 & 0b11111000) >> 3)
    let q1 = ((b0 & 0b00000111) << 2)
        |    ((b1 & 0b11000000) >> 6)
    let q2 = ((b1 & 0b00111110) >> 1)
    let q3 = ((b1 & 0b00000001) << 4)
        |    ((b2 & 0b11110000) >> 4)
    let q4 = ((b2 & 0b00001111) << 1)
        |    ((b3 & 0b10000000) >> 7)
    let q5 = ((b3 & 0b01111100) >> 2)
    let q6 = ((b3 & 0b00000011) << 3)
        |    ((b4 & 0b11100000) >> 5)
    let q7 =  (b4 & 0b00011111)

    return (q0, q1, q2, q3, q4, q5, q6, q7)
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
