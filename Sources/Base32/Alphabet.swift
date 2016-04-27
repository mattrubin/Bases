//
//  Alphabet.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

let paddingCharacter: Character = "="

// Each 5-bit group is used as an index into an array of 32 printable
// characters.  The character referenced by the index is placed in the
// output string.  These characters, identified in Table 3, below, are
// selected from US-ASCII digits and uppercase letters.
//
//                   Table 3: The Base 32 Alphabet
//
//   Value Encoding  Value Encoding  Value Encoding  Value Encoding
//       0 A             9 J            18 S            27 3
//       1 B            10 K            19 T            28 4
//       2 C            11 L            20 U            29 5
//       3 D            12 M            21 V            30 6
//       4 E            13 N            22 W            31 7
//       5 F            14 O            23 X
//       6 G            15 P            24 Y         (pad) =
//       7 H            16 Q            25 Z
//       8 I            17 R            26 2

func characterForValue(_ value: Quintet) -> Character {
    switch value {
    case  0: return "A"
    case  1: return "B"
    case  2: return "C"
    case  3: return "D"
    case  4: return "E"
    case  5: return "F"
    case  6: return "G"
    case  7: return "H"
    case  8: return "I"
    case  9: return "J"
    case 10: return "K"
    case 11: return "L"
    case 12: return "M"
    case 13: return "N"
    case 14: return "O"
    case 15: return "P"
    case 16: return "Q"
    case 17: return "R"
    case 18: return "S"
    case 19: return "T"
    case 20: return "U"
    case 21: return "V"
    case 22: return "W"
    case 23: return "X"
    case 24: return "Y"
    case 25: return "Z"
    case 26: return "2"
    case 27: return "3"
    case 28: return "4"
    case 29: return "5"
    case 30: return "6"
    case 31: return "7"
    default:
        // This function is only ever called internally, with the result of an octet-to-quintet conversion.
        // If the value is 32 or higher, it is the result of a flaw in the implementation of the algorithm,
        // and not a legitimate error case which might merit returning an optional.
        fatalError("Could not encode value \(value) as a Base32 character")
    }
}
