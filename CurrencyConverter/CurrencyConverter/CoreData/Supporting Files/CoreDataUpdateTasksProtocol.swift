//
//  CoreDataUpdateHandler.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation

protocol CoreDataUpdateTasksProtocol {
    func updateCoreData(_ coreDataUpdateTask: (()-> Void)?, backGroundThreadTask: (()->Void)?)
}

struct CoreDataUpdateHandler: CoreDataUpdateTasksProtocol {
    
    func updateCoreData(_ coreDataUpdateTask: (()-> Void)?, backGroundThreadTask: (()->Void)?) {
        PersistentStorage.shared.context.perform {
            coreDataUpdateTask?()
            DispatchQueue.global(qos: .background).async {
                backGroundThreadTask?()
            }
        }
    }
}
