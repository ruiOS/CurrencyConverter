//
//  MockNetworkMonitor.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation
@testable import CurrencyConverter

final class MockNetworkMonitor: NetworkMonitorProtocol {
    var isNetworkAvailable: Bool = true

    func set(isNetworkAvailable: Bool) {
        self.isNetworkAvailable = isNetworkAvailable
    }
}
