//
//  Alphabet.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

let paddingCharacter: String = "="

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

private let alphabet = ["A", "B", "C", "D", "E", "F", "G", "H",
                        "I", "J", "K", "L", "M", "N", "O", "P",
                        "Q", "R", "S", "T", "U", "V", "W", "X",
                        "Y", "Z", "2", "3", "4", "5", "6", "7"]

func encodedValue(_ value: Quintet) -> String {
    return alphabet[Int(value)]
}
