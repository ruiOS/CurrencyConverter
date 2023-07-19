//
//  MockNetworkMonitorDelegate.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 02/07/23.
//

import Foundation
@testable import CurrencyConverter

// MARK: - MockNetworkMonitorDelegate
final class MockNetworkMonitorDelegate: NetworkMonitorDelegate {

    var currentStatus: NetworkStatus?

    func didUpdateNetwork(with status: NetworkStatus) {
        currentStatus = status
    }
}
