//
//  SelectCurrencyBuilder.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 01/07/23.
//  
//

import UIKit

struct SelectCurrencyBuilder {

    func build(with delegate: SelectCurrencyDelegate?) -> UIViewController {
        let router = SelectCurrencyRouter()
        let presenter = SelectCurrencyPresenter(
            router: router,
            baseCurrencyManager: BaseCurrenyManager(),
            currencyRepository: CurrencyRepository(),
            delegate: delegate
        )
        let viewController  = SelectCurrencyViewController(presenter: presenter)
        presenter.view = viewController
        router.viewController = viewController
        return viewController
    }
}
