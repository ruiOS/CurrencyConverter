//
//  SelectCurrencyRouter.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 01/07/23.
//  
//

import UIKit

// MARK: - SelectCurrencyRoutable
protocol SelectCurrencyRoutable {
    func popSelectionView()
}

// MARK: - SelectCurrencyRouter
final class SelectCurrencyRouter {
    weak var viewController: UIViewController?
}

// MARK: SelectCurrencyRoutable
extension SelectCurrencyRouter: SelectCurrencyRoutable {

    func popSelectionView() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
