//
//  SelectCurrencyViewControllerTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import XCTest
import UIKit
@testable import CurrencyConverter

final class SelectCurrencyViewControllerTests: XCTestCase {

    var view: SelectCurrencyViewController!
    var mockPresenter: MockSelectCurrencyPresenter!

    override func setUp() {
        super.setUp()
        mockPresenter = MockSelectCurrencyPresenter()
        view = SelectCurrencyViewController(presenter: mockPresenter)
    }

    override func tearDown() {
        super.tearDown()
        mockPresenter = nil
        view = nil
    }

    func testViewDidLoad() {
        view.viewDidLoad()
        XCTAssertTrue(mockPresenter.isViewDidLoadTriggered)
    }

    func testSearchBarTextDidChange() {
        let expectedText = "ABC"
        view.searchBar(UISearchBar(), textDidChange: expectedText)
        XCTAssertEqual(mockPresenter.searchText, expectedText)
    }

    func testTableViewDidSelectRow() {
        let expectedIndexPath = IndexPath(row: 10, section: 0)
        view.tableView(UITableView(), didSelectRowAt: expectedIndexPath)
        XCTAssertEqual(mockPresenter.selectedIndexPath, expectedIndexPath)
    }

    func testNumberOfRows() {
        let _ = view.tableView(UITableView(), numberOfRowsInSection: 0)
        XCTAssertTrue(mockPresenter.isNumberOfRowsUsed)
    }

    func testCellForRow() {
        mockPresenter.cells = [.init(text: "INR", cellState: .none),
                               .init(text: "JPY", cellState: .none),
                               .init(text: "USD", cellState: .none)].sorted(by: {($0.text ?? "") < ($1.text ?? "")})
        var expectedRow = 0
        let _ = view.tableView(UITableView(), cellForRowAt: IndexPath(row: expectedRow, section: 0))
        XCTAssertEqual(expectedRow, mockPresenter.currentRetreivedRow)

        expectedRow = 1
        let _ = view.tableView(UITableView(), cellForRowAt: IndexPath(row: expectedRow, section: 0))
        XCTAssertEqual(expectedRow, mockPresenter.currentRetreivedRow)

        expectedRow = 2
        let _ = view.tableView(UITableView(), cellForRowAt: IndexPath(row: expectedRow, section: 0))
        XCTAssertEqual(expectedRow, mockPresenter.currentRetreivedRow)
    }
}
