//
//  CurrencyFormatter.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 02/07/23.
//

import Foundation

// MARK: - CurrencyFormatterProtocol
protocol CurrencyFormatterProtocol {
    func getFormattedString(for number: Double) -> String
}

// MARK: - CurrencyFormatter
struct CurrencyFormatter: CurrencyFormatterProtocol {

    private let numberFormtter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    init(maximumFractionDigits: Int) {
        numberFormtter.maximumFractionDigits = maximumFractionDigits
    }

    func getFormattedString(for number: Double) -> String {
        numberFormtter.string(from: number as NSNumber) ?? ""
    }
}
