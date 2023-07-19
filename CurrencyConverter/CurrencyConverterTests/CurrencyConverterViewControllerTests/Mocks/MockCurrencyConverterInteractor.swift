//
//  MockCurrencyConverterInteractor.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation
@testable import CurrencyConverter

final class MockCurrencyConverterInteractor: CurrencyConverterInteractable {

    var isConvertRatesTriggered: Bool = false
    var currencyIdentifier: String?

    func getConvertRates(for id: String) {
        isConvertRatesTriggered = true
        currencyIdentifier = id
    }
}
