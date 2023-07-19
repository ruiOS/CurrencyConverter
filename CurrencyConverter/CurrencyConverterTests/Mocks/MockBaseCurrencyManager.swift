//
//  MockBaseCurrencyManager.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation
@testable import CurrencyConverter

final class MockBaseCurrencyManager: BaseCurrencyManagerProtocol {

    var baseCurrency: CurrencyProtocol?

    func getBaseCurrency() -> CurrencyProtocol? {
        baseCurrency
    }
    
    func saveBaseCurrency(currency: CurrencyProtocol) {
        baseCurrency = currency
    }
}
