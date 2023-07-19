//
//  NetworkMonitorDelegate.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 02/07/23.
//

import Foundation

// MARK: - NetworkMonitorDelegate
protocol NetworkMonitorDelegate: AnyObject {
    func didUpdateNetwork(with status: NetworkStatus)
}
