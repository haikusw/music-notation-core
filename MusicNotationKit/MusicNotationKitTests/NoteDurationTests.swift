//
//  NoteDurationTests.swift
//  MusicNotationKit
//
//  Created by Kyle Sherman on 8/21/16.
//  Copyright © 2016 Kyle Sherman. All rights reserved.
//

import XCTest
@testable import MusicNotationKit

class NoteDurationTests: XCTestCase {

    let allValues: [NoteDuration.Value] = [
        .large,
        .long,
        .doubleWhole,
        .whole,
        .half,
        .quarter,
        .eighth,
        .sixteenth,
        .thirtySecond,
        .sixtyFourth,
        .oneTwentyEighth,
        .twoFiftySixth
    ]

    // MARK: - init(value:dotCount:)
    // MARK: Failures

    func testInitNegativeDotCount() {
        do {
            let _ = try NoteDuration(value: .quarter, dotCount: -1)
            shouldFail()
        } catch NoteDurationError.negativeDotCountInvalid {
        } catch {
            expected(NoteDurationError.negativeDotCountInvalid, actual: error)
        }
    }

    // MARK: Successes

    func testInitDotCountZero() {
        let dotCount = 0
        var currentValue: NoteDuration.Value?
        do {
            try allValues.forEach {
                currentValue = $0
                let duration = try NoteDuration(value: $0, dotCount: dotCount)
                XCTAssertEqual(duration.value, $0)
                XCTAssertEqual(duration.dotCount, dotCount)
            }
        } catch {
            XCTFail("\(error) for value: \(currentValue!)")
        }
    }

    func testInitDotCountNonZero() {
        let dotCount = 2
        var currentValue: NoteDuration.Value?
        do {
            try allValues.forEach {
                currentValue = $0
                let duration = try NoteDuration(value: $0, dotCount: dotCount)
                XCTAssertEqual(duration.value, $0)
                XCTAssertEqual(duration.dotCount, dotCount)
            }
        } catch {
            XCTFail("\(error) for value: \(currentValue!)")
        }
    }

    func testInitDotCountLargerThan4() {
        let dotCount = 5
        var currentValue: NoteDuration.Value?
        do {
            try allValues.forEach {
                currentValue = $0
                let duration = try NoteDuration(value: $0, dotCount: dotCount)
                XCTAssertEqual(duration.value, $0)
                XCTAssertEqual(duration.dotCount, dotCount)
            }
        } catch {
            XCTFail("\(error) for value: \(currentValue!)")
        }
    }

    // MARK: - equal(to:)
    // MARK: Successes

    func testEqualToForSameDuration() {
        let noteDuration = NoteDuration.eighth
        XCTAssertEqual(noteDuration.equal(to: NoteDuration.eighth), 1)
    }

    func testEqualToForSameDurationSingleDot() {
        do {
            let noteDuration = try NoteDuration(value: .quarter, dotCount: 1)
            XCTAssertEqual(noteDuration.equal(to: try NoteDuration(value: .quarter, dotCount: 1)), 1)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testEqualToForSameDurationMultipleDot() {
        do {
            let noteDuration = try NoteDuration(value: .quarter, dotCount: 3)
            XCTAssertEqual(noteDuration.equal(to: try NoteDuration(value: .quarter, dotCount: 3)), 1)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testEqualToForSmallerDuration() {
        let noteDuration = NoteDuration.sixteenth
        XCTAssertEqual(noteDuration.equal(to: NoteDuration.sixtyFourth), 4)
    }

    func testEqualToForLargerDuration() {
        let noteDuration = NoteDuration.quarter
        XCTAssertEqual(noteDuration.equal(to: NoteDuration.whole), 0.25)
    }

    func testEqualToForSmallerDurationSingleDotFromNoDot() {
        let noteDuration = NoteDuration.quarter
        XCTAssertEqual(noteDuration.equal(to: try NoteDuration(value: .eighth, dotCount: 1)), 1.25)
    }

    func testEqualToForSmallerDurationSingleDotFromSingleDot() {
        do {
            let noteDuration = try NoteDuration(value: .quarter, dotCount: 1)
            XCTAssertEqual(noteDuration.equal(to: try NoteDuration(value: .sixteenth, dotCount: 1)), 4)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    func testEqualToForSmallerDurationDoubleDotFromDoubleDot() {
        do {
            let noteDuration = try NoteDuration(value: .quarter, dotCount: 2)
            XCTAssertEqual(noteDuration.equal(to: try NoteDuration(value: .thirtySecond, dotCount: 2)), 8)
        } catch {
            XCTFail(String(describing: error))
        }
    }

    // MARK: - debugDescription

    func testDebugDescriptionNoDot() {
        XCTAssertEqual(NoteDuration.large.debugDescription, "8")
        XCTAssertEqual(NoteDuration.long.debugDescription, "4")
        XCTAssertEqual(NoteDuration.doubleWhole.debugDescription, "2")
        XCTAssertEqual(NoteDuration.whole.debugDescription, "1")
        XCTAssertEqual(NoteDuration.half.debugDescription, "1/2")
        XCTAssertEqual(NoteDuration.quarter.debugDescription, "1/4")
        XCTAssertEqual(NoteDuration.eighth.debugDescription, "1/8")
        XCTAssertEqual(NoteDuration.sixteenth.debugDescription, "1/16")
        XCTAssertEqual(NoteDuration.thirtySecond.debugDescription, "1/32")
        XCTAssertEqual(NoteDuration.sixtyFourth.debugDescription, "1/64")
        XCTAssertEqual(NoteDuration.oneTwentyEighth.debugDescription, "1/128")
        XCTAssertEqual(NoteDuration.twoFiftySixth.debugDescription, "1/256")
    }

    func testDebugDescriptionSingleDot() {
        XCTAssertEqual(try! NoteDuration(value: .quarter, dotCount: 1).debugDescription, "1/4.")
    }

    func testDebugDescriptionMultipleDots() {
        XCTAssertEqual(try! NoteDuration(value: .sixtyFourth, dotCount: 3).debugDescription, "1/64...")
    }

    // MARK: - timeSignatureValue

    func testTimeSignatureValue() {
        XCTAssertNil(NoteDuration.large.timeSignatureValue)
        XCTAssertNil(NoteDuration.long.timeSignatureValue)
        XCTAssertNil(NoteDuration.doubleWhole.timeSignatureValue)
        XCTAssertEqual(NoteDuration.whole.timeSignatureValue, 1)
        XCTAssertEqual(NoteDuration.half.timeSignatureValue, 2)
        XCTAssertEqual(NoteDuration.quarter.timeSignatureValue, 4)
        XCTAssertEqual(NoteDuration.eighth.timeSignatureValue, 8)
        XCTAssertEqual(NoteDuration.sixteenth.timeSignatureValue, 16)
        XCTAssertEqual(NoteDuration.thirtySecond.timeSignatureValue, 32)
        XCTAssertEqual(NoteDuration.sixtyFourth.timeSignatureValue, 64)
        XCTAssertEqual(NoteDuration.oneTwentyEighth.timeSignatureValue, 128)
        XCTAssertEqual(NoteDuration.twoFiftySixth.timeSignatureValue, 256)
    }
}
