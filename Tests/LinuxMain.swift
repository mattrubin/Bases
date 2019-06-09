import XCTest

import Base16Tests
import Base32Tests

var tests = [XCTestCaseEntry]()
tests += Base16Tests.__allTests()
tests += Base32Tests.__allTests()

XCTMain(tests)
