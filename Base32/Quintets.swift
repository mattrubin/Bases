//
//  Quintets.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

func quintets(b0: UInt8)
    -> (UInt8, UInt8)
{
    let q = quintets(b0, 0, 0, 0, 0)
    return (q.0, q.1)
}

func quintets(b0: UInt8, b1: UInt8)
    -> (UInt8, UInt8, UInt8, UInt8)
{
    let q = quintets(b0, b1, 0, 0, 0)
    return (q.0, q.1, q.2, q.3)
}

func quintets(b0: UInt8, b1: UInt8, b2: UInt8)
    -> (UInt8, UInt8, UInt8, UInt8, UInt8)
{
    let q = quintets(b0, b1, b2, 0, 0)
    return (q.0, q.1, q.2, q.3, q.4)
}

func quintets(b0: UInt8, b1: UInt8, b2: UInt8, b3: UInt8)
    -> (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
{
    let q = quintets(b0, b1, b2, b3, 0)
    return (q.0, q.1, q.2, q.3, q.4, q.5, q.6)
}

func quintets(b0: UInt8, b1: UInt8, b2: UInt8, b3: UInt8, b4: UInt8)
    -> (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)
{
    let q0 = ((b0 & 0b11111000) >> 3)
    let q1 = ((b0 & 0b00000111) << 2)
        |    ((b1 & 0b11000000) >> 6)
    let q2 = ((b1 & 0b00111110) >> 1)
    let q3 = ((b1 & 0b00000001) << 4)
        |    ((b2 & 0b11110000) >> 4)
    let q4 = ((b2 & 0b00001111) << 1)
        |    ((b3 & 0b10000000) >> 7)
    let q5 = ((b3 & 0b01111100) >> 2)
    let q6 = ((b3 & 0b00000011) << 3)
        |    ((b4 & 0b11100000) >> 5)
    let q7 =  (b4 & 0b00011111)

    return (q0, q1, q2, q3, q4, q5, q6, q7)
}
