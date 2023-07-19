//
//  BaseCurrenyManager.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 01/07/23.
//

import Foundation

// MARK: -  BaseCurrencyManagerProtocol
protocol BaseCurrencyManagerProtocol {
    func getBaseCurrency() -> CurrencyProtocol?
    func saveBaseCurrency(currency: CurrencyProtocol)
}

// MARK: -  BaseCurrenyManager
struct BaseCurrenyManager {
    let baseCurrencyKey = "baseCurrency"
}

// MARK: BaseCurrencyManagerProtocol
extension BaseCurrenyManager: BaseCurrencyManagerProtocol {

    func getBaseCurrency() -> CurrencyProtocol? {
        if let savedRates = UserDefaults.standard.object(forKey: baseCurrencyKey) as? Data {
            let decoder = JSONDecoder()
            if let baseCurrency = try? decoder.decode(Currency.self, from: savedRates) {
                return baseCurrency
            }
        }
        return nil
    }

    func saveBaseCurrency(currency: CurrencyProtocol) {
        if let currency = (currency as? Encodable),
           let encoded: Data = try? JSONEncoder().encode(currency) {
            UserDefaults.standard.set(encoded, forKey: baseCurrencyKey)
        }
        UserDefaults.standard.synchronize()
    }
}
