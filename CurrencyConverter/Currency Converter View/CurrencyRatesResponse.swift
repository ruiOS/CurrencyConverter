//
//  CurrencyRatesResponse.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 30/06/23.
//

import Foundation

// MARK: - CurrencyRatesResponseProtocol
protocol CurrencyRatesResponseProtocol: Codable {
    var base: String { get }
    var rates: [String:Double] { get }
}

// MARK: - CurrencyRatesResponse
struct CurrencyRatesResponse: CurrencyRatesResponseProtocol, Decodable {
    let base: String
    let rates: [String:Double]
}
