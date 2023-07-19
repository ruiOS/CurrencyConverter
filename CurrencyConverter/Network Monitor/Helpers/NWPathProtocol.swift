//
//  NWPathProtocol.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 02/07/23.
//

import Foundation
import Network

protocol NWPathProtocol  {
    var status: NWPath.Status { get }
}

extension NWPath: NWPathProtocol { }
