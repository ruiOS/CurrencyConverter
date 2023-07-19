//
//  MockSelectCurrencyDelegate.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation
@testable import CurrencyConverter

final class MockSelectCurrencyDelegate: SelectCurrencyDelegate {

    var isDidUpdateBaseCurrencTriggered: Bool = false

    func didUpdateBaseCurrency() {
        isDidUpdateBaseCurrencTriggered = true
    }
}
