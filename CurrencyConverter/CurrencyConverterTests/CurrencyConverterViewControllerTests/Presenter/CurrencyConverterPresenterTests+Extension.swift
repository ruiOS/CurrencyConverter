//
//  CurrencyConverterPresenterTests+Extension.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import XCTest
@testable import CurrencyConverter

// MARK: Interactor Listener
extension CurrencyConverterPresenterTests {

    func testDidFetchCurrencyRates_WhenBaseCurrencyIsAvailable_CurrenciesAreSaved() {
        let identifier = "USD"
        let multiplier: Double = 1
        let extectedBaseCurrency = MockCurrency(identifier: identifier, multiplier: multiplier)
        let expectedurrencies = [extectedBaseCurrency,
                                 MockCurrency(identifier: "INR", multiplier: 56),
                                 MockCurrency(identifier: "JPY", multiplier: 112)]
        presenter.didFetch(currencyRates: CurrencyRatesResponse(base: identifier, rates: [identifier: multiplier,
                                                                                          "INR": 56,
                                                                                          "JPY": 112]))
        XCTAssertEqual(mockBaseCurrencyManager.baseCurrency?.identifier, extectedBaseCurrency.identifier)
        XCTAssertEqual(mockBaseCurrencyManager.baseCurrency?.multiplier, extectedBaseCurrency.multiplier)
        XCTAssertTrue(mockTimestampSynchroniser.isSaveCurrentTimeStamp)
        XCTAssertTrue(mockView.isDataReloaded)
        XCTAssertEqual(mockView.loadingState, CurrencyConverterLoaderState.none)
        let fetchedCurrencies = mockCurrencyRepository.getAll()
        compareCurrencies(for: expectedurrencies[0], expectedCurrrency: fetchedCurrencies[fetchedCurrencies.firstIndex{ $0.identifier == expectedurrencies[0].identifier} ?? 0])
        compareCurrencies(for: expectedurrencies[1], expectedCurrrency: fetchedCurrencies[fetchedCurrencies.firstIndex{ $0.identifier == expectedurrencies[1].identifier} ?? 1])
        compareCurrencies(for: expectedurrencies[2], expectedCurrrency: fetchedCurrencies[fetchedCurrencies.firstIndex{ $0.identifier == expectedurrencies[2].identifier} ?? 2])
    }

    func compareCurrencies(for currency: CurrencyProtocol, expectedCurrrency: CurrencyProtocol) {
        XCTAssertEqual(currency.multiplier, expectedCurrrency.multiplier)
        XCTAssertEqual(currency.identifier, expectedCurrrency.identifier)
    }

    func testDidFetchCurrencyRates_WhenBaseCurrencyIsUnavailabe_CurrenciesAreNotSaved() {
        presenter.didFetch(currencyRates: CurrencyRatesResponse(base: "USD", rates: ["INR": 56,
                                                                                     "JPY": 112]))
        XCTAssertNil(mockBaseCurrencyManager.baseCurrency)
        XCTAssertFalse(mockTimestampSynchroniser.isSaveCurrentTimeStamp)
        XCTAssertFalse(mockView.isDataReloaded)
        XCTAssertEqual(mockView.loadingState , .firstTime)
        let fetchedCurrenciesCount = mockCurrencyRepository.getAll().count
        XCTAssertEqual(fetchedCurrenciesCount, 0)
    }

    func testDidFailToFetchCurrencyRates() {
        mockBaseCurrencyManager.baseCurrency = nil
        mockRouter.isRetryControllerShown = false
        presenter.didFailToFetchCurrencyRates()
        XCTAssertTrue(mockRouter.isRetryControllerShown)

        mockRouter.isRetryControllerShown = false
        mockBaseCurrencyManager.baseCurrency = MockCurrency(identifier: "USD", multiplier: 1)
        presenter.didFailToFetchCurrencyRates()
        XCTAssertFalse(mockRouter.isRetryControllerShown)
    }
}

// MARK: Router Listener
extension CurrencyConverterPresenterTests {

    func testDidTapRetry() {
        presenter.didTapRetry()
        XCTAssertEqual(mockView.loadingState, .firstTime)
    }
}

// MARK: SelectCurrencyDelegate
extension CurrencyConverterPresenterTests {

    func testDidUpdateBaseCurrency() {
        presenter.didUpdateBaseCurrency()
        XCTAssertNotNil(mockView.viewModel)
    }
}

// MARK: NetworkMonitorDelegate

extension CurrencyConverterPresenterTests {

    func testDidUpdateBaseNetwork() {
        mockTimestampSynchroniser.isSynchronisationNeeded = true
        presenter.didUpdateNetwork(with: .connected)
        XCTAssertTrue(mockRouter.isDismissRetryControllerTriggered)
    }
}
