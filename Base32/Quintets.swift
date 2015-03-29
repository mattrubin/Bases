//
//  Quintets.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

func quintets(b0: UInt8, b1: UInt8?, b2: UInt8?, b3: UInt8?, b4: UInt8?)
    -> (UInt8, UInt8, UInt8?, UInt8?, UInt8?, UInt8?, UInt8?, UInt8?)
{
    return (
        firstQuintet(b0),
        secondQuintet(b0, b1 ?? 0),
        b1.map(thirdQuintet),
        b1.map(fourthQuintet)?(b2 ?? 0),
        b2.map(fifthQuintet)?(b3 ?? 0),
        b3.map(sixthQuintet),
        b3.map(seventhQuintet)?(b4 ?? 0),
        b4.map(eigthQuintet)
    )
}



private func firstQuintet(b0: UInt8) -> UInt8 {
    return ((b0 & 0b11111000) >> 3)
}

private func secondQuintet(b0: UInt8, b1: UInt8) -> UInt8 {
    return ((b0 & 0b00000111) << 2)
        |  ((b1 & 0b11000000) >> 6)
}

private func thirdQuintet(b1: UInt8) -> UInt8 {
    return ((b1 & 0b00111110) >> 1)
}

private func fourthQuintet(b1: UInt8)(_ b2: UInt8) -> UInt8 {
    return ((b1 & 0b00000001) << 4)
        |  ((b2 & 0b11110000) >> 4)
}

private func fifthQuintet(b2: UInt8)(_ b3: UInt8) -> UInt8 {
    return ((b2 & 0b00001111) << 1)
        |  ((b3 & 0b10000000) >> 7)
}

private func sixthQuintet(b3: UInt8) -> UInt8 {
    return ((b3 & 0b01111100) >> 2)
}

private func seventhQuintet(b3: UInt8)(_ b4: UInt8) -> UInt8 {
    return ((b3 & 0b00000011) << 3)
        |  ((b4 & 0b11100000) >> 5)
}

private func eigthQuintet(b4: UInt8) -> UInt8 {
    return (b4 & 0b00011111)
}
