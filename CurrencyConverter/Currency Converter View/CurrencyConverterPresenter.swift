//
//  CurrencyConverterPresenter.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 29/06/23.
//  
//
import Foundation

// MARK: - CurrencyConverterPresentable
protocol CurrencyConverterPresentable {
    var numberOfRows: Int { get }
    func getRowData(for indexPath: IndexPath) -> CurrencyConverterCellVMProtocol

    func viewDidLoad()

    func didUpdate(text: String?)
    func shouldChangerCharacters(text: String) -> Bool

    func didPressCurrencyChange()
}

// MARK: - CurrencyConverterPresenter
final class CurrencyConverterPresenter {

    // MARK: Properties
    private let interactor: CurrencyConverterInteractable
    private let router: CurrencyConverterRoutable
    weak var view: CurrencyConverterViewable?

    private let baseCurrencyManager: BaseCurrencyManagerProtocol
    private let currencyRepository: CurrencyRepositoryProtocol
    private let timestampSynchroniser: TimestampSynchroniserProtocol
    private let currencyFormatter: CurrencyFormatterProtocol
    private let networkMonitor: NetworkMonitorProtocol

    private var synchronisationStatus: SynchronisationStatus = .synchronised
    private var baseCurrency: CurrencyProtocol? { baseCurrencyManager.getBaseCurrency() }
    private let initialCurrency: Double = 1
    private var currentPrice: Double = 0
    private let coreDataUpdateHandler: CoreDataUpdateTasksProtocol

    private var cellViewModels: [CurrencyConverterCellVMProtocol]?
    var numberOfRows: Int { cellViewModels?.count ?? 0 }

    private enum SynchronisationStatus {
        case synchronised
        case inProgress
    }

    // MARK: Initialization
    init(
        interactor: CurrencyConverterInteractable,
        router: CurrencyConverterRoutable,
        baseCurrencyManager: BaseCurrencyManagerProtocol,
        currencyRepository: CurrencyRepositoryProtocol,
        timestampSynchroniser: TimestampSynchroniserProtocol,
        currencyFormatter: CurrencyFormatterProtocol,
        networkMonitor: NetworkMonitorProtocol,
        coreDataUpdateHandler: CoreDataUpdateTasksProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.baseCurrencyManager = baseCurrencyManager
        self.currencyRepository = currencyRepository
        self.timestampSynchroniser = timestampSynchroniser
        self.currencyFormatter = currencyFormatter
        self.networkMonitor = networkMonitor
        self.coreDataUpdateHandler = coreDataUpdateHandler
    }
}

// MARK: CurrencyConverterPresentable
extension CurrencyConverterPresenter: CurrencyConverterPresentable {

    func viewDidLoad() {
        setNewBaseCurrency(with: initialCurrency)
    }

    func shouldChangerCharacters(text: String) -> Bool {
        let pattern = #"^(?!^0{2,})-?(?:\d*\.\d{0,2}|\d+\.{0,1}\d{0,2})$|^$"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return false
        }
        let range = NSRange(location: 0, length: text.utf16.count)
        let matches = regex.matches(in: text, options: [], range: range)
        let isRegexMatched = !matches.isEmpty
        return isRegexMatched
    }

    func didUpdate(text: String?) {
        let text = text ?? ""
        currentPrice = (text as NSString).doubleValue
        updateCurrencyValues()
    }

    func getRowData(for indexPath: IndexPath) -> CurrencyConverterCellVMProtocol {
        guard let viewModel = cellViewModels?[indexPath.row] else {
            return CurrencyConverterCellVM(key: "", value: "")
        }
        return viewModel
    }

    func didPressCurrencyChange() {
        router.navigateToBaseCurrencySelection(with: self)
    }
}

// MARK: CurrencyConverterInteractorListener
extension CurrencyConverterPresenter: CurrencyConverterInteractorListener {

    func didFetch(currencyRates: CurrencyRatesResponseProtocol) {
        guard let multiplier = currencyRates.rates[currencyRates.base] else {
            view?.setLoadingState(for: .firstTime)
            interactor.getConvertRates(for: "")
            return
        }
        let baseCurreny = Currency(identifier: currencyRates.base, multiplier: multiplier)
        let currencies = currencyRates.rates.map { (key, value) in
            return Currency(identifier: key, multiplier: value)
        }

        coreDataUpdateHandler.updateCoreData { [weak self] in
            guard let self else { return }
            self.currencyRepository.deleteAll()
            self.currencyRepository.create(currencies: currencies)
        } backGroundThreadTask: { [weak self] in
            guard let self else { return }
            self.baseCurrencyManager.saveBaseCurrency(currency: baseCurreny)
            self.timestampSynchroniser.saveCurrentTimeStamp()
            self.synchronisationStatus = .synchronised
            self.setNewBaseCurrency(with: self.currentPrice)
            self.updateView()
        }
    }

    func didFailToFetchCurrencyRates() {
        synchronisationStatus = .synchronised
        if baseCurrency == nil {
            router.showRetryController()
        }
    }
}

// MARK: CurrencyConverterRouterListener
extension CurrencyConverterPresenter: CurrencyConverterRouterListener {

    func didTapRetry() {
        view?.setLoadingState(for: .firstTime)
        getConvertRates()
    }
}

// MARK: SelectCurrencyDelegate
extension CurrencyConverterPresenter: SelectCurrencyDelegate {

    func didUpdateBaseCurrency() {
        viewDidLoad()
    }
}

// MARK: NetworkMonitorDelegate
extension CurrencyConverterPresenter: NetworkMonitorDelegate {
    func didUpdateNetwork(with status: NetworkStatus) {
        guard status == .connected,
              timestampSynchroniser.isSynchronisationNeeded,
              synchronisationStatus == .synchronised else { return }
        getConvertRates()
        router.dismissRetryControllerIfNeeded()
        if baseCurrency == nil {
            view?.setLoadingState(for: .firstTime)
        }
    }
}

// MARK: Private
private extension CurrencyConverterPresenter {

    func updateView() {
        view?.setLoadingState(for: .none)
        getValue()
        view?.reloadData()
    }

    func getValue() {
        guard let baseCurrency, baseCurrency.multiplier != 0 else {
            view?.setLoadingState(for: .firstTime)
            interactor.getConvertRates(for: baseCurrency?.identifier ?? "")
            return
        }
        let currencies = currencyRepository.getAll()
        cellViewModels = currencies.map {
            let multiplier = $0.multiplier / baseCurrency.multiplier
            let currentPrice = currentPrice * multiplier
            let formattedAmount = currencyFormatter.getFormattedString(for: currentPrice)
            return CurrencyConverterCellVM(key: $0.identifier,
                                           value: formattedAmount)
        }
    }

    func setNewBaseCurrency(with currency: Double) {
        view?.setTextBar(with: .init(buttonText: self.baseCurrency?.identifier ?? "", inputText: self.currencyFormatter.getFormattedString(for: currency)))
    }

    func updateCurrencyValues() {
        if baseCurrency == nil {
            if synchronisationStatus == .synchronised {
                getConvertRates()
            }
            view?.setLoadingState(for: .firstTime)
            return
        } else if timestampSynchroniser.isSynchronisationNeeded && synchronisationStatus == .synchronised {
            getConvertRates()
        }
        updateView()
    }

    func getConvertRates() {
        synchronisationStatus = .inProgress
        guard networkMonitor.isNetworkAvailable else {
            didFailToFetchCurrencyRates()
            return
        }
        interactor.getConvertRates(for: baseCurrency?.identifier ?? "")
    }
}
