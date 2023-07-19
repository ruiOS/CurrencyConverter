//
//  CurrencyConverterViewControllerTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import XCTest
import UIKit
@testable import CurrencyConverter

final class CurrencyConverterViewControllerTests: XCTestCase {
    var view: CurrencyConverterViewController!
    var presenter: MockCurrencyConverterPresenter!

    override func setUp() {
        super.setUp()
        presenter = MockCurrencyConverterPresenter()
        view = CurrencyConverterViewController(presenter: presenter)
    }

    override func tearDown() {
        super.tearDown()
        presenter = nil
        view = nil
    }

    func testCollectionViewDataSource() {
        presenter.rows = [CurrencyConverterCellVM(key: "USD", value: "1")]
        view.viewDidLoad()
        let expectedRows1 = 1
        let rowsReceived1 = view.collectionView(view.collectionView, numberOfItemsInSection: 0)
        XCTAssertEqual(expectedRows1, rowsReceived1)

        let expectdIndexPath = IndexPath(row: 0, section: 0)
        let _ = view.collectionView(view.collectionView, cellForItemAt: expectdIndexPath)
        XCTAssertEqual(expectdIndexPath, presenter.currentDataFetchedRow)

        presenter.rows = [CurrencyConverterCellVM(key: "USD", value: "1"),
                          CurrencyConverterCellVM(key: "INR", value: "56"),]
        let expectedRows2 = 2
        let rowsReceived2 = view.collectionView(view.collectionView, numberOfItemsInSection: 0)

        XCTAssertEqual(expectedRows2, rowsReceived2)

        let expectdIndexPath1 = IndexPath(row: 0, section: 0)
        let _ = view.collectionView(view.collectionView, cellForItemAt: expectdIndexPath1)
        XCTAssertEqual(expectdIndexPath1, presenter.currentDataFetchedRow)

        let expectdIndexPath2 = IndexPath(row: 1, section: 0)
        let _ = view.collectionView(view.collectionView, cellForItemAt: expectdIndexPath2)
        XCTAssertEqual(expectdIndexPath2, presenter.currentDataFetchedRow)

    }

    func testDidUpdateTextField() {
        checkTextdidUpdate(for: "")
        checkTextdidUpdate(for: "INR")
    }

    func checkTextdidUpdate(for expectedText: String) {
        view.didUpdateTextField(with: expectedText)
        XCTAssertEqual(presenter.updatedText,expectedText)
    }

    func testDidPressButton() {
        view.didPressButton()
        XCTAssertTrue(presenter.isCurrencyChangePressed)
    }

    func testShouldChangeCharactersIn() {
        let textField = UITextField()
        textField.text = "1"
        let range = NSRange(location: 0, length: 1)
        let replacementString = ""
        let expected = ""

        // When ShouldChange Character return true
        presenter.isAllowCharacterUpdate = true
        let _ = view.textField(textField, shouldChangeCharactersIn: range, replacementString: replacementString)
        XCTAssertEqual(presenter.shouldChangeString, expected)
        XCTAssertEqual(presenter.updatedText, expected)

        // When ShouldChange Character return false
        presenter.isAllowCharacterUpdate = false
        presenter.updatedText = nil
        let _ = view.textField(textField, shouldChangeCharactersIn: range, replacementString: replacementString)
        XCTAssertEqual(presenter.shouldChangeString, expected)
        XCTAssertNil(presenter.updatedText)
    }

    func checkCurrencyConverterCellVMProtocolEquatable(expectedRow: CurrencyConverterCellVMProtocol, receivedRow: CurrencyConverterCellVMProtocol) {
        XCTAssertEqual(expectedRow.key, receivedRow.key)
        XCTAssertEqual(expectedRow.value, receivedRow.value)
    }
}
