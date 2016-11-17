//
//  Alphabet.swift
//  Bases
//
//  Copyright (c) 2015-2016 Matt Rubin and the Bases authors
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

internal typealias EncodedChar = UInt8

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

internal let paddingCharacter: EncodedChar = 61
private let encodingTable: [EncodedChar] = [65, 66, 67, 68, 69, 70, 71, 72,
                                            73, 74, 75, 76, 77, 78, 79, 80,
                                            81, 82, 83, 84, 85, 86, 87, 88,
                                            89, 90, 50, 51, 52, 53, 54, 55]

internal func character(encoding quintet: Quintet) -> EncodedChar {
    return encodingTable[Int(quintet)]
}
