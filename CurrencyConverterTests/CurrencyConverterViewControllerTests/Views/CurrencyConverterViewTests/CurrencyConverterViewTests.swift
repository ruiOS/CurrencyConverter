//
//  CurrencyConverterViewTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import XCTest
import UIKit
@testable import CurrencyConverter

final class CurrencyConverterViewTests: XCTestCase {
    var view: CurrencyConverterView!
    var mockDelegate: MockCurrencyConverterViewDelegate!

    override func setUp() {
        super.setUp()
        view = CurrencyConverterView(frame: .zero)
        mockDelegate = MockCurrencyConverterViewDelegate()
        view.delegate = mockDelegate
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSetView() {
        let expectedText = "1"
        view.setView(with: CurrencyConverterViewModel(buttonText: "Test", inputText: expectedText))
        XCTAssertEqual(mockDelegate.updatedText, expectedText)
    }

    func testShouldChangeCharactersIn() {
        let expectedText = "ABC"
        let textField = UITextField()
        textField.text = expectedText
        let range = NSRange(location: 0, length: 1)
        let replacementString = "XYZ"
        let _ = view.textField(textField, shouldChangeCharactersIn: range, replacementString: replacementString)
        XCTAssertEqual(mockDelegate.shouldChangeCharactersInRange, range)
        XCTAssertEqual(mockDelegate.replacementString, replacementString)
        XCTAssertEqual(mockDelegate.textFieldText, expectedText)

    }
}
