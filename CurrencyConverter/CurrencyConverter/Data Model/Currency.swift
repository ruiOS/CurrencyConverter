//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 01/07/23.
//

import Foundation

// MARK: - CurrencyProtocol
protocol CurrencyProtocol {
    var identifier: String { get }
    var multiplier: Double { get }
}

// MARK: - Currency
struct Currency: CurrencyProtocol, Codable {
    let identifier: String
    let multiplier: Double
}
