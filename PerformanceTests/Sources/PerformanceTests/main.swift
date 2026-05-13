// SPDX-FileCopyrightText: © 2016-2026 Matt Rubin and the Bases authors
// SPDX-License-Identifier: MIT

import Base32
import CoreFoundation
import Foundation

#if os(macOS)
import Security
#endif

func measureBlock(_ block: () throws -> Void) rethrows -> CFTimeInterval {
    let startTime = CFAbsoluteTimeGetCurrent()
    try block()
    let endTime = CFAbsoluteTimeGetCurrent()
    return endTime - startTime
}

func measureEncoding(
    from data: Data,
    to encodedString: String,
    using encodingFunction: (Data) -> String,
    times: Int
) -> CFTimeInterval {
    return measureBlock {
        for _ in 0..<times {
            let result = encodingFunction(data)
            assert(encodedString == result)
        }
    }
}

func compareEncoding(from data: Data, to encodedString: String, times: Int) {
    print("Encoding \(data.count) bytes over \(times) iterations...")
    #if os(macOS)
    let secDuration = measureEncoding(from: data, to: encodedString, using: secBase32Encode, times: times)
    print("Base duration: \(secDuration)")
    #endif
    let duration = measureEncoding(from: data, to: encodedString, using: Base32.encode, times: times)
    print("  My duration: \(duration)")
    let previousBest = 0.11406124114990235
    print("Previous best: \(previousBest)")
    let improvement = 1 - (duration / previousBest)
    print("Improvement: \(round(improvement * 10000) / 100)%")
    #if os(macOS)
    print("Now \(round((secDuration / duration) * 100) / 100) times as fast as the system baseline.")
    #endif
}

#if os(macOS)
func secBase32Encode(data: Data) -> String {
    let encoder = SecEncodeTransformCreate(kSecBase32Encoding, nil)!
    SecTransformSetAttribute(encoder, kSecTransformInputAttributeName, data as CFTypeRef, nil)
    // swiftlint:disable:next force_cast
    let encodedData = SecTransformExecute(encoder, nil) as! CFData
    return String(data: encodedData as Data, encoding: .ascii)!
}
#endif

func measureDecoding(
    from encodedString: String,
    to data: Data,
    using decodingFunction: (String) throws -> Data,
    times: Int
) rethrows -> CFTimeInterval {
    return try measureBlock {
        for _ in 0..<times {
            let result = try decodingFunction(encodedString)
            assert(data == result)
        }
    }
}

func compareDecoding(from encodedString: String, to data: Data, times: Int) throws {
    print("Decoding \(data.count) bytes over \(times) iterations...")
    #if os(macOS)
    let secDuration = measureDecoding(from: encodedString, to: data, using: secBase32Decode, times: times)
    print("Base duration: \(secDuration)")
    #endif
    let duration = try measureDecoding(from: encodedString, to: data, using: Base32.decode, times: times)
    print("  My duration: \(duration)")
    let previousBest = 0.17377197742462158
    print("Previous best: \(previousBest)")
    let improvement = 1 - (duration / previousBest)
    print("Improvement: \(round(improvement * 10000) / 100)%")
    #if os(macOS)
    print("Now \(round((secDuration / duration) * 100) / 100) times as fast as the system baseline.")
    #endif
}

#if os(macOS)
func secBase32Decode(_ encodedString: String) -> Data {
    let encodedData = encodedString.data(using: .ascii)!
    let decoder = SecDecodeTransformCreate(kSecBase32Encoding, nil)!
    SecTransformSetAttribute(decoder, kSecTransformInputAttributeName, encodedData as CFTypeRef, nil)
    // swiftlint:disable:next force_cast
    let decodedData = SecTransformExecute(decoder, nil) as! CFData
    return decodedData as Data
}
#endif

func fox(times: Int) -> String {
    let foxString = "The quick brown fox jumps over a lazy dog"
    return String(repeating: foxString, count: times)
}

let fox1000 = fox(times: 1000)
let foxData = fox1000.data(using: .ascii)!
let foxResult = Base32.encode(foxData)
let n = 1000

compareEncoding(from: foxData, to: foxResult, times: n)
print()
try compareDecoding(from: foxResult, to: foxData, times: n)
print()

let c = 25
let encodingTimes = (0..<c).map({ _ in
    measureEncoding(from: foxData, to: foxResult, using: Base32.encode, times: n)
})
let encodingAverage = encodingTimes.reduce(0, +) / Double(c * n)

print(String(format: "Encoding Average: %.5f ms", encodingAverage * 1000))

let decodingTimes = try (0..<c).map({ _ in
    try measureDecoding(from: foxResult, to: foxData, using: Base32.decode, times: n)
})
let decodingAverage = decodingTimes.reduce(0, +) / Double(c * n)

print(String(format: "Decoding Average: %.5f ms", decodingAverage * 1000))
