//
//  DataParserTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 02/07/23.
//

import XCTest
@testable import CurrencyConverter

// MARK: - CurrencyRatesResponse
extension CurrencyRatesResponse: Equatable {
    public static func == (lhs: CurrencyRatesResponse, rhs: CurrencyRatesResponse) -> Bool {
        lhs.rates == rhs.rates && lhs.base == rhs.base

    }
}

// MARK: - DataParserTests
final class DataParserTests: XCTestCase {

    let parser = DataParser()

    func testParseWithData() throws {

        let responseData = """
                {
                    "disclaimer": "Usage subject to terms: https://openexchangerates.org/terms",
                    "license": "https://openexchangerates.org/license",
                    "timestamp": 1688317209,
                    "base": "USD",
                    "rates": {
                        "AED": 3.673,
                        "AFN": 85.494576,
                        "ALL": 97.542004
                    }
                }
                """.data(using: .utf8)

        let expectedResponse = CurrencyRatesResponse(base: "USD", rates: ["AED": 3.673,
                                                                          "AFN": 85.494576,
                                                                          "ALL": 97.542004])

        let expectation = XCTestExpectation(description: "Completion handler is called")
        try parser.parse(data: responseData) { (result: CurrencyRatesResponse) in
            XCTAssertEqual(result, expectedResponse)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testParseWithoutData() {
        let responseData: Data? = nil

        let expectation = XCTestExpectation(description: "Completion handler is not called")

        do {
            try parser.parse(data: responseData) { (result: CurrencyRatesResponse) in
                XCTFail("Completion handler should not be called")
            }
        } catch {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
