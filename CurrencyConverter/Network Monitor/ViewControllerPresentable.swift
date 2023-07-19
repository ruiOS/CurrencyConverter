//
//  ViewControllerPresentable.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 18/07/23.
//

import UIKit

protocol ViewControllerPresentable: AnyObject {

    func present(_ viewControllerToPresent: Self, animated flag: Bool, completion: (() -> Void)?)
}

extension ViewControllerPresentable {

    func present(_ viewControllerToPresent: Self, animated flag: Bool, completion: (() -> Void)? = nil) {
        self.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

extension UIViewController: ViewControllerPresentable {

}
