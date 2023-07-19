//
//  PersistentStorageTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import XCTest
import CoreData
@testable import CurrencyConverter

final class PersistentStorageTests: XCTestCase {

    var persistentStorage: PersistentStorage!

    override func setUp() {
        super.setUp()
        deleteAllContacts()
        persistentStorage = PersistentStorage.shared
    }

    override func tearDown() {
        persistentStorage = nil
        super.tearDown()
    }

    func testSaveAndFetchContext() {
        let context = persistentStorage.context
        let entity = NSEntityDescription.insertNewObject(forEntityName: CDCurrency.entityName, into: context)
        persistentStorage.saveContext()

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CDCurrency.entityName)
        let results = try? context.fetch(fetchRequest)
        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(results?.first, entity)
    }

    func deleteAllContacts() {
        let entityNames: [CDCurrency] = PersistentStorage.shared.fetchManagedObject(managedObject: CDCurrency.self)
        entityNames.forEach { PersistentStorage.shared.context.delete($0) }
        PersistentStorage.shared.saveContext()
    }
}
