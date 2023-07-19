//
//  MockCurrencyFormatter.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation
@testable import CurrencyConverter

final class MockCurrencyFormatter: CurrencyFormatterProtocol {

    var inputNumber: Double?

    func getFormattedString(for number: Double) -> String {
        inputNumber = number
        return ""
    }
}
