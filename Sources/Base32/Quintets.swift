//
//  Quintets.swift
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

typealias Byte = UInt8
typealias Quintet = UInt8

func quintetsFromBytes(_ firstByte: Byte, _ secondByte: Byte, _ thirdByte: Byte, _ fourthByte: Byte, _ fifthByte: Byte)
    -> (Quintet, Quintet, Quintet, Quintet, Quintet, Quintet, Quintet, Quintet)
{
    return (
        firstQuintet(firstByte: firstByte),
        secondQuintet(firstByte: firstByte, secondByte: secondByte),
        thirdQuintet(secondByte: secondByte),
        fourthQuintet(secondByte: secondByte, thirdByte: thirdByte),
        fifthQuintet(thirdByte: thirdByte, fourthByte: fourthByte),
        sixthQuintet(fourthByte: fourthByte),
        seventhQuintet(fourthByte: fourthByte, fifthByte: fifthByte),
        eighthQuintet(fifthByte: fifthByte)
    )
}

func quintetsFromBytes(_ firstByte: Byte, _ secondByte: Byte, _ thirdByte: Byte, _ fourthByte: Byte)
    -> (Quintet, Quintet, Quintet, Quintet, Quintet, Quintet, Quintet)
{
    return (
        firstQuintet(firstByte: firstByte),
        secondQuintet(firstByte: firstByte, secondByte: secondByte),
        thirdQuintet(secondByte: secondByte),
        fourthQuintet(secondByte: secondByte, thirdByte: thirdByte),
        fifthQuintet(thirdByte: thirdByte, fourthByte: fourthByte),
        sixthQuintet(fourthByte: fourthByte),
        seventhQuintet(fourthByte: fourthByte, fifthByte: 0)
    )
}

func quintetsFromBytes(_ firstByte: Byte, _ secondByte: Byte, _ thirdByte: Byte)
    -> (Quintet, Quintet, Quintet, Quintet, Quintet)
{
    return (
        firstQuintet(firstByte: firstByte),
        secondQuintet(firstByte: firstByte, secondByte: secondByte),
        thirdQuintet(secondByte: secondByte),
        fourthQuintet(secondByte: secondByte, thirdByte: thirdByte),
        fifthQuintet(thirdByte: thirdByte, fourthByte: 0)
    )
}

func quintetsFromBytes(_ firstByte: Byte, _ secondByte: Byte)
    -> (Quintet, Quintet, Quintet, Quintet)
{
    return (
        firstQuintet(firstByte: firstByte),
        secondQuintet(firstByte: firstByte, secondByte: secondByte),
        thirdQuintet(secondByte: secondByte),
        fourthQuintet(secondByte: secondByte, thirdByte: 0)
    )
}

func quintetsFromBytes(_ firstByte: Byte)
    -> (Quintet, Quintet)
{
    return (
        firstQuintet(firstByte: firstByte),
        secondQuintet(firstByte: firstByte, secondByte: 0)
    )
}



private func firstQuintet(firstByte: Byte) -> Quintet {
    return ((firstByte & 0b11111000) >> 3)
}

private func secondQuintet(firstByte: Byte, secondByte: Byte) -> Quintet {
    return ((firstByte & 0b00000111) << 2)
        | ((secondByte & 0b11000000) >> 6)
}

private func thirdQuintet(secondByte: Byte) -> Quintet {
    return ((secondByte & 0b00111110) >> 1)
}

private func fourthQuintet(secondByte: Byte, thirdByte: Byte) -> Quintet {
    return ((secondByte & 0b00000001) << 4)
        | ((thirdByte & 0b11110000) >> 4)
}

private func fifthQuintet(thirdByte: Byte, fourthByte: Byte) -> Quintet {
    return ((thirdByte & 0b00001111) << 1)
        | ((fourthByte & 0b10000000) >> 7)
}

private func sixthQuintet(fourthByte: Byte) -> Quintet {
    return ((fourthByte & 0b01111100) >> 2)
}

private func seventhQuintet(fourthByte: Byte, fifthByte: Byte) -> Quintet {
    return ((fourthByte & 0b00000011) << 3)
        | ((fifthByte & 0b11100000) >> 5)
}

private func eighthQuintet(fifthByte: Byte) -> Quintet {
    return (fifthByte & 0b00011111)
}
