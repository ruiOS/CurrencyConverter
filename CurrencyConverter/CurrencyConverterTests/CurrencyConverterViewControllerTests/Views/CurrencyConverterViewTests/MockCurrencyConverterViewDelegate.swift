//
//  MockCurrencyConverterViewDelegate.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import UIKit
@testable import CurrencyConverter

extension CurrencyConverterViewDelegate {
    func didPressButton() { }
}

final class MockCurrencyConverterViewDelegate: CurrencyConverterViewDelegate {

    var shouldChangeCharactersInRange: NSRange?
    var replacementString: String?
    var textFieldText: String?
    var updatedText: String?

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        shouldChangeCharactersInRange = range
        replacementString = string
        textFieldText = textField.text
        return true
    }

    func didUpdateTextField(with text: String?) {
        updatedText = text
    }
}
