//
//  CurrencyRepositoryTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 02/07/23.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyRepositoryTests: XCTestCase {

    let repository = CurrencyRepository()

    override func setUp() {
        super.setUp()
        repository.deleteAll()
    }

    override func tearDown() {
        super.tearDown()
        repository.deleteAll()
    }

    func testCreateAndGetCurrency() {
        let currency = MockCurrency(identifier: "USD", multiplier: 1)
        repository.create(currency: currency)

        let fetchedCurrency = repository.get(by: currency.identifier)
        XCTAssertNotNil(fetchedCurrency)
        XCTAssertEqual(fetchedCurrency?.identifier, currency.identifier)
        XCTAssertEqual(fetchedCurrency?.multiplier, currency.multiplier)
    }

    func testCreateAndGetCurrencies() {
        let currencies: [Currency] = [.init(identifier: "USD", multiplier: 1),
                                      .init(identifier: "JPY", multiplier: 144.34),
                                      .init(identifier: "INR", multiplier: 82.1)].sorted(by: {$0.identifier < $1.identifier})
        repository.create(currencies: currencies)

        let fetchedCurrencies = repository.getAll()
        let isSameArray = fetchedCurrencies.elementsEqual(currencies, by: {$0.identifier == $1.identifier && $0.multiplier == $1.multiplier})
        XCTAssertTrue(isSameArray)
    }

    func testUpdateCurrency() {
        let identifier = "USD"
        let currency1 = MockCurrency(identifier: identifier, multiplier: 1)
        repository.create(currency: currency1)
        let currency2 = MockCurrency(identifier: identifier, multiplier: 2)
        let isUpdated = repository.update(currency: currency2)
        let fetchedCurrency = repository.get(by: identifier)
        XCTAssertTrue(isUpdated)
        XCTAssertEqual(fetchedCurrency?.identifier, identifier)
        XCTAssertEqual(fetchedCurrency?.multiplier, currency2.multiplier)
        XCTAssertNotEqual(fetchedCurrency?.multiplier, currency1.multiplier)
    }

    func testDeleteCurrency() {
        let identifier = "USD"
        let currency = MockCurrency(identifier: identifier, multiplier: 1)
        repository.create(currency: currency)
        let isDeleted = repository.delete(using: identifier)
        XCTAssertTrue(isDeleted)
        XCTAssertNil(repository.get(by: identifier))
    }

    func testDeleteAllCurrencies() {
        let currencies: [Currency] = [.init(identifier: "USD", multiplier: 1),
                                      .init(identifier: "JPY", multiplier: 144.34),
                                      .init(identifier: "INR", multiplier: 82.1)].sorted(by: {$0.identifier < $1.identifier})
        repository.create(currencies: currencies)
        repository.deleteAll()
        let isDBEmpty = repository.getAll().isEmpty
        XCTAssertTrue(isDBEmpty)
    }
}
