//
//  TimestampSynchroniser.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 02/07/23.
//

import QuartzCore

// MARK: - TimestampSynchroniserProtocol
protocol TimestampSynchroniserProtocol {
    var isSynchronisationNeeded: Bool { get }
    func saveCurrentTimeStamp()
}

// MARK: - TimestampSynchroniser
struct TimestampSynchroniser {
    let lastRefreshedTimeStampKey = "lastRefreshedTimeStamp"
    let synchronisationIntervalInMin: Double
}

// MARK: TimestampSynchroniserProtocol
extension TimestampSynchroniser: TimestampSynchroniserProtocol {

    var isSynchronisationNeeded: Bool {
        let curentTimeStamp = CACurrentMediaTime()
        let previousTimeStamp = getLastSynchronisedTimeStamp()
        if previousTimeStamp == 0 { return true }
        return (curentTimeStamp - previousTimeStamp)/(60) > synchronisationIntervalInMin
    }
    
    func saveCurrentTimeStamp() {
        let curentTimeStamp = CACurrentMediaTime()
        UserDefaults.standard.set(curentTimeStamp, forKey: lastRefreshedTimeStampKey)
        UserDefaults.standard.synchronize()
    }
}

// MARK: - Private
private extension TimestampSynchroniser {

    func getLastSynchronisedTimeStamp() -> Double {
        return UserDefaults.standard.double(forKey: lastRefreshedTimeStampKey)
    }
}
