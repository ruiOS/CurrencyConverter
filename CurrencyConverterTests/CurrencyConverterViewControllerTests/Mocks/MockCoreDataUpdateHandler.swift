//
//  MockCoreDataUpdateHandler.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

@testable import CurrencyConverter

final class MockCoreDataUpdateHandler: CoreDataUpdateTasksProtocol {

    func updateCoreData(_ coreDataUpdateTask: (() -> Void)?, backGroundThreadTask: (() -> Void)?) {
        coreDataUpdateTask?()
        backGroundThreadTask?()
    }
}
