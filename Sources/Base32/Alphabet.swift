//
//  Alphabet.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

let paddingCharacter: CUnsignedChar = 61

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

private let alphabet: [CUnsignedChar] = [65, 66, 67, 68, 69, 70, 71, 72,
                                         73, 74, 75, 76, 77, 78, 79, 80,
                                         81, 82, 83, 84, 85, 86, 87, 88,
                                         89, 90, 50, 51, 52, 53, 54, 55]

func encodedValue(_ value: Quintet) -> CUnsignedChar {
    return alphabet[Int(value)]
}
