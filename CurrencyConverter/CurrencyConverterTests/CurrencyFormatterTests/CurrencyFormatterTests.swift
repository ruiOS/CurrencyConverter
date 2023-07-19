//
//  CurrencyFormatterTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 02/07/23.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyFormatterTests: XCTestCase {

    let formatter = CurrencyFormatter(maximumFractionDigits: 2)

    func testGetFormattedString_WhenNegativeNumber_ReturnsUptoTwoDigitsWithNegativeSign() {
        let number = 1234.567
        let expectedText = "1,234.57"
        executeTest(for: number, expectedText: expectedText)
    }

    func testGetFormattedString_WhenPositiveNumber_ReturnsUptoTwoDigitsWithNoSign() {
        let number = -987.654
        let expectedText = "-987.65"
        executeTest(for: number, expectedText: expectedText)
    }

    func testGetFormattedString_WhenNoNumberAfterDecimal_ReturnsNumberWithOutDecimal() {
        let number: Double = 42
        let expectedText = "42"
        executeTest(for: number, expectedText: expectedText)
    }

    func executeTest(for number: Double, expectedText: String) {
        let formattedString = formatter.getFormattedString(for: number)
        XCTAssertEqual(formattedString, expectedText)
    }
}
