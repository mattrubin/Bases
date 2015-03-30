//
//  AlphabetTests.swift
//  Bases
//
//  Created by Matt Rubin on 3/29/15.
//  Copyright (c) 2015 Matt Rubin. All rights reserved.
//

import XCTest
import Base32

class AlphabetTests: XCTestCase {

    func testCharacterEncoding() {
        assertCharacter("A", forValue: 0)
        assertCharacter("B", forValue: 1)
        assertCharacter("C", forValue: 2)
        assertCharacter("D", forValue: 3)
        assertCharacter("E", forValue: 4)
        assertCharacter("F", forValue: 5)
        assertCharacter("G", forValue: 6)
        assertCharacter("H", forValue: 7)
        assertCharacter("I", forValue: 8)
        assertCharacter("J", forValue: 9)
        assertCharacter("K", forValue: 10)
        assertCharacter("L", forValue: 11)
        assertCharacter("M", forValue: 12)
        assertCharacter("N", forValue: 13)
        assertCharacter("O", forValue: 14)
        assertCharacter("P", forValue: 15)
        assertCharacter("Q", forValue: 16)
        assertCharacter("R", forValue: 17)
        assertCharacter("S", forValue: 18)
        assertCharacter("T", forValue: 19)
        assertCharacter("U", forValue: 20)
        assertCharacter("V", forValue: 21)
        assertCharacter("W", forValue: 22)
        assertCharacter("X", forValue: 23)
        assertCharacter("Y", forValue: 24)
        assertCharacter("Z", forValue: 25)
        assertCharacter("2", forValue: 26)
        assertCharacter("3", forValue: 27)
        assertCharacter("4", forValue: 28)
        assertCharacter("5", forValue: 29)
        assertCharacter("6", forValue: 30)
        assertCharacter("7", forValue: 31)
    }

    private func assertCharacter(expectedCharacter: Character, forValue value: UInt8) {
        let resultingCharacter = characterForValue(value)
        XCTAssertEqual(resultingCharacter, expectedCharacter,
            "\(value) translated to \"\(resultingCharacter)\" (expected \"\(expectedCharacter)\")")
    }

}
