//
//  PersistentStorage.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 01/07/23.
//

import CoreData

// MARK: PersistentStorage
final class PersistentStorage {

    //MARK: Singleton
    static let shared: PersistentStorage = PersistentStorage()

    private init() {}

    // MARK: Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrencyConverter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var context = persistentContainer.viewContext

    // MARK: Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchManagedObject<T: NSManagedObject>(managedObject: T.Type) -> [T] {
        do {
            if let result: [T] = try context.fetch(managedObject.fetchRequest()) as? [T] {
                return result
            }
        } catch {
            debugPrint(error)
        }
        return [T]()
    }

    func fetchObjects<T: NSFetchRequestResult & NSManagedObjectEntityProtocol>( usingPredicate predicate: NSPredicate? = nil,
                                                                                withSortDescriptors sortDescriptors: [NSSortDescriptor]? = nil) -> [T]? {
        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName)
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }

        if let sortDescriptors = sortDescriptors{
            fetchRequest.sortDescriptors = sortDescriptors
        }

        do {
            return try PersistentStorage.shared.context.fetch(fetchRequest)
        } catch {
            debugPrint(error)
        }
        return nil
    }
}
