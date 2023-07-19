//
//  MockCurrencyConverterView.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation
@testable import CurrencyConverter

final class MockCurrencyConverterView: CurrencyConverterViewable {

    var isDataReloaded: Bool = false
    var viewModel: CurrencyConverterViewModel?
    var loadingState: CurrencyConverterLoaderState?

    func reloadData() {
        isDataReloaded = true
    }

    func setTextBar(with viewModel: CurrencyConverterViewModel) {
        self.viewModel = viewModel
    }

    func setLoadingState(for loadingState: CurrencyConverterLoaderState) {
        self.loadingState = loadingState
    }
}
