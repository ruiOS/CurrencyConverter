//
//  NetworkMonitor.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 02/07/23.
//

import Foundation
import Network

// MARK: - NetworkMonitorProtocol
protocol NetworkMonitorProtocol {
    var isNetworkAvailable: Bool { get }
}

// MARK: - NetworkMonitor
final class NetworkMonitor<T: NWPathMonitorProtocol> {
    private let monitor: T
    weak var delegate: NetworkMonitorDelegate?

    init(monitor: T = NWPathMonitor(), delegate: NetworkMonitorDelegate? = nil) {
        self.monitor = monitor
        self.delegate = delegate
        initialiseNetworkMonitor()
    }
}

// MARK: NetworkMonitorProtocol
extension NetworkMonitor: NetworkMonitorProtocol {
    var isNetworkAvailable: Bool { monitor.currentPath.status == .satisfied }
}

// MARK: Private
private extension NetworkMonitor {

    func initialiseNetworkMonitor() {
        monitor.pathUpdateHandler = { [weak self] newPath in
            let status: NetworkStatus = newPath.status == .satisfied ? .connected : .disconnected
            self?.delegate?.didUpdateNetwork(with: status)
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
}
