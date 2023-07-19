//
//  CurrencyRepositoryProtocol.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 01/07/23.
//

import Foundation

protocol CurrencyRepositoryProtocol {
    func create(currency: CurrencyProtocol)
    func create(currencies: [CurrencyProtocol])
    func getAll() -> [CurrencyProtocol]
    func get(by id: String) -> CurrencyProtocol?
    func update(currency: CurrencyProtocol) -> Bool
    func delete(using id: String) -> Bool
    func deleteAll()
}
