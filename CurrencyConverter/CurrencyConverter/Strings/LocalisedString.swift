//
//  LocalisedString.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation

@propertyWrapper struct LocalisedString {
    let key: String
    let comment: String

    var wrappedValue: String {
        get {
            let localisedString = NSLocalizedString(key, comment: comment)
            if key == localisedString {
                return comment
            } else {
                return localisedString
            }
        }
    }
}
