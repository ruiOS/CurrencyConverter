//
//  MockCurrencyRepository.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation
@testable import CurrencyConverter

final class MockCurrencyRepository: CurrencyRepositoryProtocol {

    var currencies: [CurrencyProtocol] = []

    func create(currency: CurrencyProtocol) {
        currencies.append(currency)
    }
    
    func create(currencies: [CurrencyProtocol]) {
        self.currencies.append(contentsOf: currencies)
    }
    
    func getAll() -> [CurrencyProtocol] {
        currencies
    }
    
    func get(by id: String) -> CurrencyProtocol? {
        currencies.first { $0.identifier == id }
    }
    
    func update(currency: CurrencyProtocol) -> Bool {
        let index = currencies.firstIndex { $0.identifier == currency.identifier }
        guard let index else { return false }
        currencies[index] = currency
        return true
    }
    
    func delete(using id: String) -> Bool {
        let index = currencies.firstIndex { $0.identifier == id }
        guard let index else { return false }
        currencies.remove(at: index)
        return true
    }
    
    func deleteAll() {
        currencies.removeAll()
    }
}
