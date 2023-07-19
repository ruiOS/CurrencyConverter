//
//  MockCurrencye.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 02/07/23.
//

import Foundation
@testable import CurrencyConverter

struct MockCurrency: CurrencyProtocol {
    let identifier: String
    let multiplier: Double
}
