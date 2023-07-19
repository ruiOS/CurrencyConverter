//
//  CurrencyConverterBuilder.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 29/06/23.
//  
//

import UIKit

struct CurrencyConverterBuilder {

    func build() -> UIViewController {
        let interactor = CurrencyConverterInteractor(dataParser: DataParser())
        let router = CurrencyConverterRouter()
        let networkMonitor = NetworkMonitor()
        let presenter = CurrencyConverterPresenter(interactor: interactor,
                                                   router: router,
                                                   baseCurrencyManager: BaseCurrenyManager(),
                                                   currencyRepository: CurrencyRepository(),
                                                   timestampSynchroniser: TimestampSynchroniser(synchronisationIntervalInMin: 30),
                                                   currencyFormatter: CurrencyFormatter(maximumFractionDigits: 2),
                                                   networkMonitor: networkMonitor,
                                                   coreDataUpdateHandler: CoreDataUpdateHandler())
        networkMonitor.delegate = presenter
        let viewController  = CurrencyConverterViewController(presenter: presenter)
        presenter.view = viewController
        interactor.listener = presenter
        router.listener = presenter
        router.viewController = viewController
        return viewController
    }
}
