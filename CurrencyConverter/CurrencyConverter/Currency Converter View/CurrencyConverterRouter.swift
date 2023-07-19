//
//  CurrencyConverterRouter.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 01/07/23.
//

import UIKit

// MARK: - CurrencyConverterRoutable
protocol CurrencyConverterRoutable {
    func navigateToBaseCurrencySelection(with delegate: SelectCurrencyDelegate?)
    func showRetryController()
    func dismissRetryControllerIfNeeded()
}

// MARK: - CurrencyConverterRouterListener
protocol CurrencyConverterRouterListener: AnyObject {
    func didTapRetry()
}

// MARK: - CurrencyConverterRouter
final class CurrencyConverterRouter {
    weak var viewController: UIViewController?
    weak var listener: CurrencyConverterRouterListener?
    private let selectCurrencyBuiler = SelectCurrencyBuilder()
    private var retryController: UIViewController?
}

// MARK: CurrencyConverterRoutable
extension CurrencyConverterRouter: CurrencyConverterRoutable {

    func navigateToBaseCurrencySelection(with delegate: SelectCurrencyDelegate?) {
         viewController?.navigationController?.pushViewController(selectCurrencyBuiler.build(with: delegate), animated: true)
    }

    func showRetryController() {
        DispatchQueue.main.async { [weak self] in
            let action = UIAlertAction(title: AppStrings.retry, style: .default) { [weak self]_ in
                self?.retryController = nil
                self?.listener?.didTapRetry()
            }
            let alertController = UIAlertController(title: AppStrings.networkConnectionError, message: nil, preferredStyle: .alert)
            alertController.addAction(action)
            self?.retryController = alertController
            self?.viewController?.navigationController?.present(alertController, animated: true)
        }
    }

    func dismissRetryControllerIfNeeded() {
        if let retryController {
            DispatchQueue.main.async {
                retryController.dismiss(animated: true)
            }
        }
    }
}
