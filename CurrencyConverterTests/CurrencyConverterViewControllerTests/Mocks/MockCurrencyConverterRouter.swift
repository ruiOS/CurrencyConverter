//
//  MockCurrencyConverterRouter.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation
@testable import CurrencyConverter

final class MockCurrencyConverterRouter: CurrencyConverterRoutable {

    var isNavigatedToBaseCurrencySelection: Bool = false
    weak var currencySelectiondelegate: SelectCurrencyDelegate?
    var isRetryControllerShown: Bool = false
    var isDismissRetryControllerTriggered: Bool = false

    func navigateToBaseCurrencySelection(with delegate: SelectCurrencyDelegate?) {
        self.currencySelectiondelegate = delegate
        isNavigatedToBaseCurrencySelection = true
    }
    
    func showRetryController() {
        isRetryControllerShown = true
    }
    
    func dismissRetryControllerIfNeeded() {
        isDismissRetryControllerTriggered = true
    }
}
