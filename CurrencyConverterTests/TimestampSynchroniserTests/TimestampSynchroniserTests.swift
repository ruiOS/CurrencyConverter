//
//  TimestampSynchroniserTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 02/07/23.
//

import XCTest
@testable import CurrencyConverter

final class TimestampSynchroniserTests: XCTest {

    let synchroniser = TimestampSynchroniser(synchronisationIntervalInMin: 30)

    func testIsSynchronisationNeeded() {

        let lastSynchronisedTimeStamp1 = CACurrentMediaTime() - (30 * 60)
        UserDefaults.standard.set(lastSynchronisedTimeStamp1, forKey: synchroniser.lastRefreshedTimeStampKey)
        XCTAssertTrue(synchroniser.isSynchronisationNeeded)

        let lastSynchronisedTimeStamp2 = CACurrentMediaTime() - (5 * 60)
        UserDefaults.standard.set(lastSynchronisedTimeStamp2, forKey: synchroniser.lastRefreshedTimeStampKey)
        XCTAssertFalse(synchroniser.isSynchronisationNeeded)
    }

    func testSaveCurrentTimeStamp() {
        synchroniser.saveCurrentTimeStamp()
        let savedTimeStamp = UserDefaults.standard.double(forKey: synchroniser.lastRefreshedTimeStampKey)
        let currentTimestamp = CACurrentMediaTime()
        XCTAssertEqual(savedTimeStamp, currentTimestamp)
    }

}
