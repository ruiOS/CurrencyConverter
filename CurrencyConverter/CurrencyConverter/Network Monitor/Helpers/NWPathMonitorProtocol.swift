//
//  NWPathMonitorProtocol.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 02/07/23.
//

import Foundation
import Network

protocol NWPathMonitorProtocol: AnyObject {

    associatedtype T: NWPathProtocol
    var currentPath: T { get }
    var pathUpdateHandler: ((_ newPath: T) -> Void)? { get set }
    func start(queue: DispatchQueue)
}


extension NWPathMonitor: NWPathMonitorProtocol { }
