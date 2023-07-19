//
//  MockNWPath.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 02/07/23.
//

import Foundation
import Network
@testable import CurrencyConverter

struct MockNWPath: NWPathProtocol {
    var status: NWPath.Status
}
