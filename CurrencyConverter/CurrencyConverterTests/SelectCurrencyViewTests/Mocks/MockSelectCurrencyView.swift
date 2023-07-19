//
//  MockSelectCurrencyView.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation
@testable import CurrencyConverter

final class MockSelectCurrencyView: SelectCurrencyViewable {

    var isReloadDataTriggered: Bool = false

    func reloadData() {
        isReloadDataTriggered = true
    }
}
