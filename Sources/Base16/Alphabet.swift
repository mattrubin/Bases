//
//  Alphabet.swift
//  Bases
//
//  Copyright (c) 2016-2018 Matt Rubin and the Bases authors
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
