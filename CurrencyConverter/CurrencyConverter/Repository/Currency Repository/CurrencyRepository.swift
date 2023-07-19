//
//  CurrencyRepository.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 01/07/23.
//

import Foundation

struct CurrencyRepository: CurrencyRepositoryProtocol {

    private let identifierKey = "identifier"

    func create(currency: CurrencyProtocol) {
        addCurrencyToRecords(currency: currency)
        PersistentStorage.shared.saveContext()
    }

    func create(currencies: [CurrencyProtocol]) {
        currencies.forEach { addCurrencyToRecords(currency: $0) }
        PersistentStorage.shared.saveContext()
    }

    func getAll() -> [CurrencyProtocol] {
        let sortDescriptors = [NSSortDescriptor(key: identifierKey, ascending: true)]
        guard let result: [CDCurrency] =  PersistentStorage.shared.fetchObjects(withSortDescriptors: sortDescriptors) else
        { return [] }
        let currenciesArray = result.map({ convertToCurrency(cdCurrency: $0) })
        return currenciesArray
    }

    func get(by id: String) -> CurrencyProtocol? {
        guard let fetchResult: [CDCurrency] = PersistentStorage.shared.fetchObjects(usingPredicate: NSPredicate(format: "\(identifierKey)==%@", id as CVarArg), withSortDescriptors: nil),
              !fetchResult.isEmpty else { return nil }
        return convertToCurrency(cdCurrency: fetchResult.first)
    }

    func update(currency: CurrencyProtocol) -> Bool {
        guard let fetchResult: [CDCurrency] = PersistentStorage.shared.fetchObjects(usingPredicate: NSPredicate(format: "\(identifierKey)==%@", currency.identifier as CVarArg), withSortDescriptors: nil),
              !fetchResult.isEmpty,
              let cdCurrency = fetchResult.first else { return false}

        cdCurrency.identifier = currency.identifier
        cdCurrency.multiplier = (currency.multiplier) as NSNumber

        PersistentStorage.shared.saveContext()
        return true
    }

    func delete(using id: String) -> Bool {
        guard let fetchResult: [CDCurrency] = PersistentStorage.shared.fetchObjects(usingPredicate: NSPredicate(format: "\(identifierKey)==%@", id as CVarArg), withSortDescriptors: nil),
              !fetchResult.isEmpty,
              let cdCurrency = fetchResult.first else { return false}
        PersistentStorage.shared.context.delete(cdCurrency)
        PersistentStorage.shared.saveContext()
        return true
    }

    func deleteAll() {
        let entityNames: [CDCurrency] = PersistentStorage.shared.fetchManagedObject(managedObject: CDCurrency.self)
        entityNames.forEach { PersistentStorage.shared.context.delete($0) }
        PersistentStorage.shared.saveContext()
    }
}

private extension CurrencyRepository {

    func addCurrencyToRecords(currency: CurrencyProtocol) {
        guard !update(currency: currency) else { return }
        let cdCurrency = CDCurrency(context: PersistentStorage.shared.context)
        cdCurrency.multiplier = (currency.multiplier) as NSNumber
        cdCurrency.identifier = currency.identifier
    }

    func convertToCurrency(cdCurrency: CDCurrency?) -> CurrencyProtocol {
        guard let identifier = cdCurrency?.identifier, let multiplier = cdCurrency?.multiplier else {
            return Currency(identifier: "", multiplier: 0)
        }
        return Currency(identifier: identifier, multiplier: Double(truncating: multiplier))
    }
}
