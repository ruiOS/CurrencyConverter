//
//  MockSelectCurrencyRouter.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation
@testable import CurrencyConverter

final class MockRouter: SelectCurrencyRoutable {

    var isPopSelectionViewTriggered: Bool = false

    func popSelectionView() {
        isPopSelectionViewTriggered = true
    }
}

