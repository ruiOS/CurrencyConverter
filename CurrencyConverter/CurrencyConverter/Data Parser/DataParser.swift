//
//  DataParser.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 02/07/23.
//

import Foundation

// MARK: - DataParserProtocol
protocol DataParserProtocol {
    func parse<T:Decodable>(data responseData: Data?, completionBlock: ((T)-> Void)) throws
}

// MARK: - DataParser
struct DataParser: DataParserProtocol {
    func parse<T:Decodable>(data responseData: Data?, completionBlock: ((T)-> Void)) throws {
        let data = try JSONDecoder().decode(T.self, from: responseData ?? Data())
        completionBlock(data)
    }
}
