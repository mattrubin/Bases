//
//  Alphabet.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

public func characterForValue(value: UInt8) -> Character? {
    switch value {
    case  0: return "A"
    case  1: return "B"
    case  2: return "C"
    case  3: return "D"
    case  4: return "E"
    case  5: return "F"
    case  6: return "G"
    case  7: return "H"
    case  8: return "I"
    case  9: return "J"
    case 10: return "K"
    case 11: return "L"
    case 12: return "M"
    case 13: return "N"
    case 14: return "O"
    case 15: return "P"
    case 16: return "Q"
    case 17: return "R"
    case 18: return "S"
    case 19: return "T"
    case 20: return "U"
    case 21: return "V"
    case 22: return "W"
    case 23: return "X"
    case 24: return "Y"
    case 25: return "Z"
    case 26: return "2"
    case 27: return "3"
    case 28: return "4"
    case 29: return "5"
    case 30: return "6"
    case 31: return "7"
    default: return nil
    }
}
