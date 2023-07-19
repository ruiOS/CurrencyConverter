//
//  MockNWNetworkMonitor.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 02/07/23.
//

import Foundation
@testable import CurrencyConverter

// MARK: - NWPathMonitorProtocol
extension NWPathMonitorProtocol {
    func start(queue: DispatchQueue) { }
}

// MARK: - MockNWNetworkMonitor
final class MockNWNetworkMonitor: NWPathMonitorProtocol {

    var currentPath: MockNWPath = .init(status: .unsatisfied)
    var pathUpdateHandler: ((_ newPath: MockNWPath) -> Void)?

    init(with simulatedPath: MockNWPath) {
        self.currentPath = simulatedPath
        simulate(pathUpdate: simulatedPath)
    }

    func simulate(pathUpdate: MockNWPath) {
        currentPath = pathUpdate
        pathUpdateHandler?(pathUpdate)
    }
}
