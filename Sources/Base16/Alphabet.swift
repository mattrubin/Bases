// SPDX-FileCopyrightText: © 2016-2018 Matt Rubin and the Bases authors
// SPDX-License-Identifier: MIT

internal typealias Byte = UInt8
internal typealias EncodedChar = UInt8

internal let encodingTable: [EncodedChar] = [
    48, 49, 50, 51, 52, 53, 54, 55,
    56, 57, 65, 66, 67, 68, 69, 70,
]

private let __: Byte? = nil
private let decodingTable: [Byte?] = [
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __,
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __,
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __,
    00, 01, 02, 03, 04, 05, 06, 07, 08, 09, __, __, __, __, __, __,
    __, 10, 11, 12, 13, 14, 15, __, __, __, __, __, __, __, __, __,
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __,
    __, 10, 11, 12, 13, 14, 15, __, __, __, __, __, __, __, __, __,
    __, __, __, __, __, __, __, __, __, __, __, __, __, __, __, __,
]

internal func byte(decoding char: EncodedChar) throws -> Byte {
    guard let byte = decodingTable[Int(char)] else {
        throw Base16.Error.nonAlphabetCharacter
    }
    return byte
}
