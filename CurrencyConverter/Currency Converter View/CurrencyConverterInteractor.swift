//
//  CurrencyConverterInteractor.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 29/06/23.
//  
//

import Foundation

// MARK: - CurrencyConverterInteractable
protocol CurrencyConverterInteractable {
    func getConvertRates(for id: String)
}

// MARK: - CurrencyConverterInteractorListener
protocol CurrencyConverterInteractorListener: AnyObject {
    func didFetch(currencyRates: CurrencyRatesResponseProtocol)
    func didFailToFetchCurrencyRates()
}

// MARK: - CurrencyConverterInteractor
final class CurrencyConverterInteractor {

    weak var listener: CurrencyConverterInteractorListener?
    private let dataParser: DataParserProtocol

    init(dataParser: DataParserProtocol) {
        self.dataParser = dataParser
    }
}

// MARK: CurrencyConverterInteractable
extension CurrencyConverterInteractor: CurrencyConverterInteractable {

    func getConvertRates(for id: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }

            let urlString = "https://openexchangerates.org/api/latest.json"
            guard var url = URL(string: urlString) else { return }
            url.append(queryItems: self.getQueryParams(for: id))

            URLSession.shared.dataTask(with: URLRequest(url: url)) { [weak self] (data, response, error) in
                guard let self else { return }
                do {
                    try self.dataParser.parse(data: data) { [weak self] (ratesResponse: CurrencyRatesResponse) in
                        self?.listener?.didFetch(currencyRates: ratesResponse)
                    }
                } catch {
                    self.listener?.didFailToFetchCurrencyRates()
                }
            }.resume()
        }
    }
}

// MARK: Private
private extension CurrencyConverterInteractor {

    func getQueryParams(for currency: String) -> [URLQueryItem] {
        guard !currency.isEmpty else {
            return [getKeyQueryParam()]
        }
        return [getKeyQueryParam(), URLQueryItem(name: "base", value: currency)]
    }

    func getKeyQueryParam() -> URLQueryItem {
        .init(name: "app_id", value: "210c08d04e2f43e6bfe101fe7eeec533")
    }
}
