//
//  BlockEncoding.swift
//  Bases
//
//  Copyright (c) 2016 Matt Rubin and the Bases authors
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

internal typealias EncodedBlock = (EncodedChar, EncodedChar, EncodedChar, EncodedChar, EncodedChar,
    EncodedChar, EncodedChar, EncodedChar)

internal func encodeBlock(bytes: UnsafePointer<Byte>, size: Int) -> EncodedBlock {
    switch size {
    case 1:
        return encodeBlock(bytes[0])
    case 2:
        return encodeBlock(bytes[0], bytes[1])
    case 3:
        return encodeBlock(bytes[0], bytes[1], bytes[2])
    case 4:
        return encodeBlock(bytes[0], bytes[1], bytes[2], bytes[3])
    case 5:
        return encodeBlock(bytes[0], bytes[1], bytes[2], bytes[3], bytes[4])
    default:
        fatalError()
    }
}

private func encodeBlock(_ b0: Byte, _ b1: Byte, _ b2: Byte, _ b3: Byte, _ b4: Byte) -> EncodedBlock {
    let q = quintetsFromBytes(b0, b1, b2, b3, b4)
    let c0 = character(encoding: q.0)
    let c1 = character(encoding: q.1)
    let c2 = character(encoding: q.2)
    let c3 = character(encoding: q.3)
    let c4 = character(encoding: q.4)
    let c5 = character(encoding: q.5)
    let c6 = character(encoding: q.6)
    let c7 = character(encoding: q.7)
    return (c0, c1, c2, c3, c4, c5, c6, c7)
}

private func encodeBlock(_ b0: Byte, _ b1: Byte, _ b2: Byte, _ b3: Byte) -> EncodedBlock {
    let q = quintetsFromBytes(b0, b1, b2, b3)
    let c0 = character(encoding: q.0)
    let c1 = character(encoding: q.1)
    let c2 = character(encoding: q.2)
    let c3 = character(encoding: q.3)
    let c4 = character(encoding: q.4)
    let c5 = character(encoding: q.5)
    let c6 = character(encoding: q.6)
    let c7 = paddingCharacter
    return (c0, c1, c2, c3, c4, c5, c6, c7)
}

private func encodeBlock(_ b0: Byte, _ b1: Byte, _ b2: Byte) -> EncodedBlock {
    let q = quintetsFromBytes(b0, b1, b2)
    let c0 = character(encoding: q.0)
    let c1 = character(encoding: q.1)
    let c2 = character(encoding: q.2)
    let c3 = character(encoding: q.3)
    let c4 = character(encoding: q.4)
    let c5 = paddingCharacter
    let c6 = paddingCharacter
    let c7 = paddingCharacter
    return (c0, c1, c2, c3, c4, c5, c6, c7)
}

private func encodeBlock(_ b0: Byte, _ b1: Byte) -> EncodedBlock {
    let q = quintetsFromBytes(b0, b1)
    let c0 = character(encoding: q.0)
    let c1 = character(encoding: q.1)
    let c2 = character(encoding: q.2)
    let c3 = character(encoding: q.3)
    let c4 = paddingCharacter
    let c5 = paddingCharacter
    let c6 = paddingCharacter
    let c7 = paddingCharacter
    return (c0, c1, c2, c3, c4, c5, c6, c7)
}

private func encodeBlock(_ b0: Byte) -> EncodedBlock {
    let q = quintetsFromBytes(b0)
    let c0 = character(encoding: q.0)
    let c1 = character(encoding: q.1)
    let c2 = paddingCharacter
    let c3 = paddingCharacter
    let c4 = paddingCharacter
    let c5 = paddingCharacter
    let c6 = paddingCharacter
    let c7 = paddingCharacter
    return (c0, c1, c2, c3, c4, c5, c6, c7)
}
