//
//  Quintets.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

typealias Byte = UInt8
typealias Quintet = UInt8

func quintetsFromBytes(_ firstByte: Byte, _ secondByte: Byte, _ thirdByte: Byte, _ fourthByte: Byte, _ fifthByte: Byte)
    -> (Quintet, Quintet, Quintet, Quintet, Quintet, Quintet, Quintet, Quintet)
{
    return (
        firstQuintet(b0: firstByte),
        secondQuintet(b0: firstByte, secondByte),
        thirdQuintet(b1: secondByte),
        fourthQuintet(b1: secondByte, b2: thirdByte),
        fifthQuintet(b2: thirdByte, b3: fourthByte),
        sixthQuintet(b3: fourthByte),
        seventhQuintet(b3: fourthByte, b4: fifthByte),
        eighthQuintet(b4: fifthByte)
    )
}

func quintetsFromBytes(_ firstByte: Byte, _ secondByte: Byte, _ thirdByte: Byte, _ fourthByte: Byte)
    -> (Quintet, Quintet, Quintet, Quintet, Quintet, Quintet, Quintet)
{
    return (
        firstQuintet(b0: firstByte),
        secondQuintet(b0: firstByte, secondByte),
        thirdQuintet(b1: secondByte),
        fourthQuintet(b1: secondByte, b2: thirdByte),
        fifthQuintet(b2: thirdByte, b3: fourthByte),
        sixthQuintet(b3: fourthByte),
        seventhQuintet(b3: fourthByte, b4: 0)
    )
}

func quintetsFromBytes(_ firstByte: Byte, _ secondByte: Byte, _ thirdByte: Byte)
    -> (Quintet, Quintet, Quintet, Quintet, Quintet)
{
    return (
        firstQuintet(b0: firstByte),
        secondQuintet(b0: firstByte, secondByte),
        thirdQuintet(b1: secondByte),
        fourthQuintet(b1: secondByte, b2: thirdByte),
        fifthQuintet(b2: thirdByte, b3: 0)
    )
}

func quintetsFromBytes(_ firstByte: Byte, _ secondByte: Byte)
    -> (Quintet, Quintet, Quintet, Quintet)
{
    return (
        firstQuintet(b0: firstByte),
        secondQuintet(b0: firstByte, secondByte),
        thirdQuintet(b1: secondByte),
        fourthQuintet(b1: secondByte, b2: 0)
    )
}

func quintetsFromBytes(_ firstByte: Byte)
    -> (Quintet, Quintet)
{
    return (
        firstQuintet(b0: firstByte),
        secondQuintet(b0: firstByte, 0)
    )
}



private func firstQuintet(b0: Byte) -> Quintet {
    return ((b0 & 0b11111000) >> 3)
}

private func secondQuintet(b0: Byte, _ b1: Byte) -> Quintet {
    return ((b0 & 0b00000111) << 2)
        |  ((b1 & 0b11000000) >> 6)
}

private func thirdQuintet(b1: Byte) -> Quintet {
    return ((b1 & 0b00111110) >> 1)
}

private func fourthQuintet(b1: Byte, b2: Byte) -> Quintet {
    return ((b1 & 0b00000001) << 4)
        |  ((b2 & 0b11110000) >> 4)
}

private func fifthQuintet(b2: Byte, b3: Byte) -> Quintet {
    return ((b2 & 0b00001111) << 1)
        |  ((b3 & 0b10000000) >> 7)
}

private func sixthQuintet(b3: Byte) -> Quintet {
    return ((b3 & 0b01111100) >> 2)
}

private func seventhQuintet(b3: Byte, b4: Byte) -> Quintet {
    return ((b3 & 0b00000011) << 3)
        |  ((b4 & 0b11100000) >> 5)
}

private func eighthQuintet(b4: Byte) -> Quintet {
    return (b4 & 0b00011111)
}
