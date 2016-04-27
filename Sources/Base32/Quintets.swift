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
