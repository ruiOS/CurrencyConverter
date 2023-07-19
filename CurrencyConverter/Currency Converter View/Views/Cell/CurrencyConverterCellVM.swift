//
//  CurrencyConverterCellVM.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 02/07/23.
//

import Foundation

// MARK: - CurrencyConverterCellVMProtocol
protocol CurrencyConverterCellVMProtocol {
    var key: String { get }
    var value: String { get }
}

// MARK: - CurrencyConverterCellVM
struct CurrencyConverterCellVM: CurrencyConverterCellVMProtocol {
    let key: String
    let value: String
}
