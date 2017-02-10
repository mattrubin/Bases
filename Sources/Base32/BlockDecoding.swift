//
//  BlockDecoding.swift
//  Bases
//
//  Copyright (c) 2017 Matt Rubin and the Bases authors
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

internal typealias DecodedBlock = (Byte?, Byte?, Byte?, Byte?, Byte?)

internal func decodeBlock(chars: UnsafePointer<EncodedChar>, size: Int) throws -> DecodedBlock {
    switch size {
    case 1:
        fatalError()
    case 2:
        return try decodeBlock(chars[0], chars[1])
    case 3:
        fatalError()
    case 4:
        return try decodeBlock(chars[0], chars[1], chars[2], chars[3])
    case 5:
        return try decodeBlock(chars[0], chars[1], chars[2], chars[3], chars[4])
    case 6:
        fatalError()
    case 7:
        return try decodeBlock(chars[0], chars[1], chars[2], chars[3], chars[4], chars[5], chars[6])
    case 8:
        return try decodeBlock(chars[0], chars[1], chars[2], chars[3], chars[4], chars[5], chars[6], chars[7])
    default:
        fatalError()
    }
}
private func decodeBlock(_ c0: EncodedChar, _ c1: EncodedChar, _ c2: EncodedChar, _ c3: EncodedChar, _ c4: EncodedChar, _ c5: EncodedChar, _ c6: EncodedChar, _ c7: EncodedChar) throws -> DecodedBlock {
    let q = (try quintet(decoding: c0),
             try quintet(decoding: c1),
             try quintet(decoding: c2),
             try quintet(decoding: c3),
             try quintet(decoding: c4),
             try quintet(decoding: c5),
             try quintet(decoding: c6),
             try quintet(decoding: c7))
    let bytes = bytesFromQuintets(q.0, q.1, q.2, q.3, q.4, q.5, q.6, q.7)
    return (bytes.0, bytes.1, bytes.2, bytes.3, bytes.4)
}

private func decodeBlock(_ c0: EncodedChar, _ c1: EncodedChar, _ c2: EncodedChar, _ c3: EncodedChar, _ c4: EncodedChar, _ c5: EncodedChar, _ c6: EncodedChar) throws -> DecodedBlock {
    let q = (try quintet(decoding: c0),
             try quintet(decoding: c1),
             try quintet(decoding: c2),
             try quintet(decoding: c3),
             try quintet(decoding: c4),
             try quintet(decoding: c5),
             try quintet(decoding: c6))
    let bytes = bytesFromQuintets(q.0, q.1, q.2, q.3, q.4, q.5, q.6)
    return (bytes.0, bytes.1, bytes.2, bytes.3, nil)
}

private func decodeBlock(_ c0: EncodedChar, _ c1: EncodedChar, _ c2: EncodedChar, _ c3: EncodedChar, _ c4: EncodedChar) throws -> DecodedBlock {
    let q = (try quintet(decoding: c0),
             try quintet(decoding: c1),
             try quintet(decoding: c2),
             try quintet(decoding: c3),
             try quintet(decoding: c4))
    let bytes = bytesFromQuintets(q.0, q.1, q.2, q.3, q.4)
    return (bytes.0, bytes.1, bytes.2, nil, nil)
}

private func decodeBlock(_ c0: EncodedChar, _ c1: EncodedChar, _ c2: EncodedChar, _ c3: EncodedChar) throws -> DecodedBlock {
    let q = (try quintet(decoding: c0),
             try quintet(decoding: c1),
             try quintet(decoding: c2),
             try quintet(decoding: c3))
    let bytes = bytesFromQuintets(q.0, q.1, q.2, q.3)
    return (bytes.0, bytes.1, nil, nil, nil)
}

private func decodeBlock(_ c0: EncodedChar, _ c1: EncodedChar) throws -> DecodedBlock {
    let q = (try quintet(decoding: c0),
             try quintet(decoding: c1))
    let byte0 = bytesFromQuintets(q.0, q.1)
    return (byte0, nil, nil, nil, nil)
}

// MARK: -

func bytesFromQuintets(_ first: Quintet, _ second: Quintet, _ third: Quintet, _ fourth: Quintet, _ fifth: Quintet, _ sixth: Quintet, _ seventh: Quintet, _ eighth: Quintet) -> (Byte, Byte, Byte, Byte, Byte) {
    return (
        firstByte(firstQuintet: first, secondQuintet: second),
        secondByte(secondQuintet: second, thirdQuintet: third, fourthQuintet: fourth),
        thirdByte(fourthQuintet: fourth, fifthQuintet: fifth),
        fourthByte(fifthQuintet: fifth, sixthQuintet: sixth, seventhQuintet: seventh),
        fifthByte(seventhQuintet: seventh, eighthQuintet: eighth)
    )
}

func bytesFromQuintets(_ first: Quintet, _ second: Quintet, _ third: Quintet, _ fourth: Quintet, _ fifth: Quintet, _ sixth: Quintet, _ seventh: Quintet) -> (Byte, Byte, Byte, Byte) {
    return (
        firstByte(firstQuintet: first, secondQuintet: second),
        secondByte(secondQuintet: second, thirdQuintet: third, fourthQuintet: fourth),
        thirdByte(fourthQuintet: fourth, fifthQuintet: fifth),
        fourthByte(fifthQuintet: fifth, sixthQuintet: sixth, seventhQuintet: seventh)
    )
}

func bytesFromQuintets(_ first: Quintet, _ second: Quintet, _ third: Quintet, _ fourth: Quintet, _ fifth: Quintet) -> (Byte, Byte, Byte) {
    return (
        firstByte(firstQuintet: first, secondQuintet: second),
        secondByte(secondQuintet: second, thirdQuintet: third, fourthQuintet: fourth),
        thirdByte(fourthQuintet: fourth, fifthQuintet: fifth)
    )
}

func bytesFromQuintets(_ first: Quintet, _ second: Quintet, _ third: Quintet, _ fourth: Quintet) -> (Byte, Byte) {
    return (
        firstByte(firstQuintet: first, secondQuintet: second),
        secondByte(secondQuintet: second, thirdQuintet: third, fourthQuintet: fourth)
    )
}


func bytesFromQuintets(_ first: Quintet, _ second: Quintet) -> (Byte) {
    return (
        firstByte(firstQuintet: first, secondQuintet: second)
    )
}

// MARK: -

func firstByte(firstQuintet: Quintet, secondQuintet: Quintet) -> Byte {
    return ((firstQuintet & 0b11111) << 3)
        | ((secondQuintet & 0b11100) >> 2)

}

func secondByte(secondQuintet: Quintet, thirdQuintet: Quintet, fourthQuintet: Quintet) -> Byte {
    return ((secondQuintet & 0b00011) << 6)
        | ((thirdQuintet & 0b11111) << 1)
        | ((fourthQuintet & 0b10000) >> 4)

}

func thirdByte(fourthQuintet: Quintet, fifthQuintet: Quintet) -> Byte {
    return ((fourthQuintet & 0b01111) << 4)
        | ((fifthQuintet & 0b11110) >> 1)

}

func fourthByte(fifthQuintet: Quintet, sixthQuintet: Quintet, seventhQuintet: Quintet) -> Byte {
    return ((fifthQuintet & 0b00001) << 7)
        | ((sixthQuintet & 0b11111) << 2)
        | ((seventhQuintet & 0b11000) >> 3)

}

func fifthByte(seventhQuintet: Quintet, eighthQuintet: Quintet) -> Byte {
    return ((seventhQuintet & 0b00111) << 5)
        | (eighthQuintet & 0b11111)

}
