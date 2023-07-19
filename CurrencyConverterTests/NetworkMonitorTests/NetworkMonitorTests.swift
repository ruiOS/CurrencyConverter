//
//  NetworkMonitorTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 02/07/23.
//

import XCTest
import Network
@testable import CurrencyConverter

final class NetworkMonitorTests: XCTestCase {
    
    var networkMonitor: NetworkMonitor<MockNWNetworkMonitor>!
    var mockNetworkProvider: MockNWNetworkMonitor!
    var mockDelegate: MockNetworkMonitorDelegate!

    override func setUp() {
        super.setUp()
        mockNetworkProvider = MockNWNetworkMonitor(with: .init(status: .requiresConnection))
        networkMonitor = NetworkMonitor(monitor: mockNetworkProvider)
        mockDelegate = MockNetworkMonitorDelegate()
        networkMonitor.delegate = mockDelegate
    }

    override func tearDown() {
        networkMonitor = nil
        mockNetworkProvider = nil
        mockDelegate = nil
        super.tearDown()
    }

    // MARK: isNetworkAvailable
    func testNetworkAvailability() {
        let requiresConnectionPath = MockNWPath(status: .requiresConnection)
        checkIfNetworkAvailabilityIsFalse(for: requiresConnectionPath)

        let unsatisfiedPath = MockNWPath(status: .unsatisfied)
        checkIfNetworkAvailabilityIsFalse(for: unsatisfiedPath)

        let satisfiedPath = MockNWPath(status: .satisfied)
        mockNetworkProvider.simulate(pathUpdate: satisfiedPath)
        XCTAssertTrue(networkMonitor.isNetworkAvailable)
    }

    func checkIfNetworkAvailabilityIsFalse(for path: MockNWPath) {
        mockNetworkProvider.simulate(pathUpdate: path)
        XCTAssertFalse(networkMonitor.isNetworkAvailable)
    }

    // MARK: Delegate
    func testIfDelegateIsTriggered() {

        let requiresConnectionPath = MockNWPath(status: .requiresConnection)
        checkIfDelegateIsCalled(for: requiresConnectionPath, expectedStatus: .disconnected)

        let unsatisfiedPath = MockNWPath(status: .unsatisfied)
        checkIfDelegateIsCalled(for: unsatisfiedPath, expectedStatus: .disconnected)

        let satisfiedPath = MockNWPath(status: .satisfied)
        checkIfDelegateIsCalled(for: satisfiedPath, expectedStatus: .connected)
    }

    func checkIfDelegateIsCalled(for path: MockNWPath, expectedStatus: NetworkStatus) {
        mockNetworkProvider.simulate(pathUpdate: path)
        XCTAssertEqual(mockDelegate.currentStatus, expectedStatus)
    }
}
