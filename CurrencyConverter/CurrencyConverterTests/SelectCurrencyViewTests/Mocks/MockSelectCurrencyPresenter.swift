//
//  MockSelectCurrencyPresenter.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation
@testable import CurrencyConverter

// MARK: - SelectCurrencyPresentable
extension SelectCurrencyPresentable {
    func backButtonPressed() { }
}

// MARK: - MockSelectCurrencyPresenter
final class MockSelectCurrencyPresenter: SelectCurrencyPresentable {

    var isViewDidLoadTriggered: Bool = false
    var isNumberOfRowsUsed: Bool = false
    var selectedIndexPath: IndexPath?
    var searchText: String?
    var currentRetreivedRow: Int?

    var cells: [SelectCurrencyCellViewModel] = []
    var numberOfRows: Int {
        isNumberOfRowsUsed = true
        return cells.count
    }

    func cellForRow(at indexPath: IndexPath) -> SelectCurrencyCellViewModel {
        currentRetreivedRow = indexPath.row
        return cells[indexPath.row]
    }

    func didSelectRow(at indexPath: IndexPath) {
        selectedIndexPath = indexPath
    }

    func viewDidLoad() {
        isViewDidLoadTriggered = true
    }

    func didSearch(for searchText: String) {
        self.searchText = searchText
    }
}
