//
//  MockTimestampSynchroniser.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation
@testable import CurrencyConverter

final class MockTimestampSynchroniser: TimestampSynchroniserProtocol {

    var isSynchronisationNeeded: Bool = false
    var isSaveCurrentTimeStamp: Bool = false

    func saveCurrentTimeStamp() {
        self.isSaveCurrentTimeStamp = true
    }

    func set(isSynchronisationNeeded: Bool) {
        self.isSynchronisationNeeded = isSynchronisationNeeded
    }
}
