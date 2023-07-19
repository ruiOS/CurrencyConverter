//
//  AppStrings.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 03/07/23.
//

import Foundation

struct AppStrings {

    @LocalisedString(key: "CURRENCY_CONVERTER_TITLE", comment: "Currency Converter")
    static var currencyConverterTitle: String

    @LocalisedString(key: "RETRY", comment: "Retry")
    static var retry: String

    @LocalisedString(key: "NETWORK_CONNECTION_ERROR", comment: "Please connect to network and try again")
    static var networkConnectionError: String

    @LocalisedString(key: "SEARCH_CURRENCIES", comment: "Search Currencies")
    static var searchCurrencies: String
}
