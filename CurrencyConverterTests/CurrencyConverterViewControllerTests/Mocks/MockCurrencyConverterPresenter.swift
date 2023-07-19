//
//  MockCurrencyConverterPresenter.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation
@testable import CurrencyConverter

final class MockCurrencyConverterPresenter: CurrencyConverterPresentable {

    var numberOfRows: Int { rows.count }
    var rows: [CurrencyConverterCellVM] = []

    var isViewDidLoadTriggered: Bool = false
    var updatedText: String? = nil
    var isAllowCharacterUpdate: Bool = false
    var isCurrencyChangePressed: Bool = false
    var shouldChangeString: String?
    var currentDataFetchedRow: IndexPath?

    func getRowData(for indexPath: IndexPath) -> CurrencyConverterCellVMProtocol {
        currentDataFetchedRow = indexPath
        return CurrencyConverterCellVM(key: "", value: "")
    }

    func viewDidLoad() {
        isViewDidLoadTriggered = true
    }

    func didUpdate(text: String?) {
        updatedText = text
    }

    func shouldChangerCharacters(text: String) -> Bool {
        shouldChangeString = text
        return isAllowCharacterUpdate
    }

    func didPressCurrencyChange() {
        isCurrencyChangePressed = true
    }
}
