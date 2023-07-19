//
//  LocalisedStringTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import XCTest
@testable import CurrencyConverter

final class LocalisedStringTests: XCTestCase {

    func testLoaclisedStrings() {

        @LocalisedString(key: "CURRENCY_CONVERTER_TITLE", comment: "Currency Converter")
        var currencyConverterTitle: String

        @LocalisedString(key: "RETRY", comment: "Retry")
        var retry: String

        @LocalisedString(key: "NETWORK_CONNECTION_ERROR", comment: "Please connect to network and try again")
        var networkConnectionError: String

        @LocalisedString(key: "SEARCH_CURRENCIES", comment: "Search Currencies")
        var searchCurrencies: String

        XCTAssertEqual(currencyConverterTitle, AppStrings.currencyConverterTitle)
        XCTAssertEqual(retry, AppStrings.retry)
        XCTAssertEqual(networkConnectionError, AppStrings.networkConnectionError)
        XCTAssertEqual(searchCurrencies, AppStrings.searchCurrencies)
    }
}
