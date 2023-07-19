//
//  CDCurrency.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 01/07/23.
//

import CoreData

// MARK: - CDCurrency
@objc(CDCurrency)
final class CDCurrency: NSManagedObject {
    @NSManaged var multiplier: NSNumber?
    @NSManaged var identifier: String?
}

// MARK: - NSManagedObjectEntityProtocol
extension CDCurrency: NSManagedObjectEntityProtocol {

    static var entityName: String {
        "CDCurrency"
    }
}
