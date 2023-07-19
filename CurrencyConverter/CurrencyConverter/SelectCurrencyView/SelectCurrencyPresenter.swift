//
//  SelectCurrencyPresenter.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 01/07/23.
//  
//
import Foundation

// MARK: - SelectCurrencyPresentable
protocol SelectCurrencyPresentable {

    var numberOfRows: Int { get }
    func cellForRow(at indexPath: IndexPath) -> SelectCurrencyCellViewModel
    func didSelectRow(at indexPath: IndexPath)

    func viewDidLoad()
    func backButtonPressed()

    func didSearch(for searchText: String)
}

protocol SelectCurrencyDelegate: AnyObject {
    func didUpdateBaseCurrency()
}

// MARK: - SelectCurrencyPresenter
final class SelectCurrencyPresenter {
    private let router: SelectCurrencyRoutable
    weak var view: SelectCurrencyViewable?
    private let baseCurrency: CurrencyProtocol?
    private let currencies: [CurrencyProtocol]
    private let baseCurrencyManager: BaseCurrencyManagerProtocol
    weak var delegate: SelectCurrencyDelegate?
    private var displayCurrencies: [CurrencyProtocol]

    var numberOfRows: Int {
        return displayCurrencies.count
    }

    init(
        router: SelectCurrencyRoutable,
        baseCurrencyManager: BaseCurrencyManagerProtocol,
        currencyRepository: CurrencyRepositoryProtocol,
        delegate: SelectCurrencyDelegate?
    ) {
        self.router = router
        self.baseCurrencyManager = baseCurrencyManager
        self.baseCurrency = baseCurrencyManager.getBaseCurrency()
        self.currencies = currencyRepository.getAll()
        self.displayCurrencies = self.currencies
        self.delegate = delegate
    }
}

// MARK: SelectCurrencyPresentable
extension SelectCurrencyPresenter: SelectCurrencyPresentable {
    func viewDidLoad() {
        view?.reloadData()
    }

    func backButtonPressed() {
        router.popSelectionView()
    }

    func cellForRow(at indexPath: IndexPath) -> SelectCurrencyCellViewModel {
        let text = displayCurrencies[indexPath.row].identifier
        return SelectCurrencyCellViewModel(text: text, cellState: getCellState(for: text))
    }

    func didSelectRow(at indexPath: IndexPath) {
        let newBaseCurrency = displayCurrencies[indexPath.row]
        if let baseCurrency = baseCurrency, newBaseCurrency.identifier == baseCurrency.identifier {
            return
        }
        baseCurrencyManager.saveBaseCurrency(currency: newBaseCurrency)
        router.popSelectionView()
        delegate?.didUpdateBaseCurrency()
    }

    func didSearch(for searchText: String) {
        displayCurrencies = searchText.isEmpty ? currencies : currencies.filter { $0.identifier.range(of: searchText, options: .caseInsensitive) != nil }
        view?.reloadData()
    }
}

// MARK: Private
private extension SelectCurrencyPresenter {
    func getCellState(for text: String) -> SelectCurrencyCellState {
        guard let id = baseCurrency?.identifier else { return .none }
        return id == text ? .currentBase : .none
    }
}
