//
//  BaseCurrenyManagerTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 29/06/23.
//

import XCTest
@testable import CurrencyConverter

final class BaseCurrenyManagerTests: XCTestCase {

    var manager: BaseCurrenyManager = BaseCurrenyManager()

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: manager.baseCurrencyKey)
    }

    func testGetBaseCurrency_WhenNoSavedCurrency_ReturnsNil() {
        let expectedCurrency: Currency? = nil
        let baseCurrency = manager.getBaseCurrency()
        XCTAssertEqual(baseCurrency?.identifier, expectedCurrency?.identifier)
        XCTAssertEqual(baseCurrency?.multiplier, expectedCurrency?.multiplier)
    }

    func testSaveBaseCurrency_WhenValidCurrency_CorrectlySavesCurrency() {
        let currency = Currency(identifier: "USD", multiplier: 1)
        manager.saveBaseCurrency(currency: currency)
        let savedCurrency = manager.getBaseCurrency()
        XCTAssertEqual(savedCurrency?.identifier, currency.identifier)
        XCTAssertEqual(savedCurrency?.multiplier, currency.multiplier)
    }
}
