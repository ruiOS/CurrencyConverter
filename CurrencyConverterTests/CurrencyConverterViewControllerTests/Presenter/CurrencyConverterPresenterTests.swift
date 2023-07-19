//
//  CurrencyConverterPresenterTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import XCTest
@testable import CurrencyConverter

final class CurrencyConverterPresenterTests: XCTestCase {
    var presenter: CurrencyConverterPresenter!
    var mockInteractor: MockCurrencyConverterInteractor!
    var mockRouter: MockCurrencyConverterRouter!
    var mockView: MockCurrencyConverterView!
    var mockBaseCurrencyManager: MockBaseCurrencyManager!
    var mockCurrencyRepository: MockCurrencyRepository!
    var mockTimestampSynchroniser: MockTimestampSynchroniser!
    var mockCurrencyFormatter: MockCurrencyFormatter!
    var mockNetworkMonitor: MockNetworkMonitor!
    var mockCoreDataUpdateHandler = MockCoreDataUpdateHandler()

    override func setUp() {
        super.setUp()
        mockInteractor = MockCurrencyConverterInteractor()
        mockRouter = MockCurrencyConverterRouter()
        mockView = MockCurrencyConverterView()
        mockBaseCurrencyManager = MockBaseCurrencyManager()
        mockCurrencyRepository = MockCurrencyRepository()
        mockTimestampSynchroniser = MockTimestampSynchroniser()
        mockCurrencyFormatter = MockCurrencyFormatter()
        mockNetworkMonitor = MockNetworkMonitor()
        presenter = CurrencyConverterPresenter(
            interactor: mockInteractor,
            router: mockRouter,
            baseCurrencyManager: mockBaseCurrencyManager,
            currencyRepository: mockCurrencyRepository,
            timestampSynchroniser: mockTimestampSynchroniser,
            currencyFormatter: MockCurrencyFormatter(),
            networkMonitor: mockNetworkMonitor,
            coreDataUpdateHandler: mockCoreDataUpdateHandler
        )
        presenter.view = mockView
    }

    override func tearDown() {
        presenter = nil
        mockInteractor = nil
        mockRouter = nil
        mockView = nil
        mockBaseCurrencyManager = nil
        mockCurrencyRepository = nil
        mockTimestampSynchroniser = nil
        mockCurrencyFormatter = nil
        mockNetworkMonitor = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testViewDidLoad() {
        presenter = CurrencyConverterPresenter(
            interactor: mockInteractor,
            router: mockRouter,
            baseCurrencyManager: mockBaseCurrencyManager,
            currencyRepository: mockCurrencyRepository,
            timestampSynchroniser: mockTimestampSynchroniser,
            currencyFormatter: CurrencyFormatter(maximumFractionDigits: 2),
            networkMonitor: mockNetworkMonitor,
            coreDataUpdateHandler: mockCoreDataUpdateHandler
        )
        presenter.view = mockView

        let initialCurrency = 1.0
        let currrencyIdentifier = "USD"
        let baseCurrency = Currency(identifier: currrencyIdentifier, multiplier: initialCurrency)
        mockBaseCurrencyManager.saveBaseCurrency(currency: baseCurrency)

        presenter.viewDidLoad()

        XCTAssertEqual(mockView.viewModel?.buttonText, currrencyIdentifier)
        XCTAssertEqual(mockView.viewModel?.inputText, "1")
    }

    func testShouldChangeCharacters_InvalidInput() {
        shoulChangeCharactersIn(invalidInPut: "00")
        shoulChangeCharactersIn(invalidInPut: "00.")
        shoulChangeCharactersIn(invalidInPut: "I")
        shoulChangeCharactersIn(invalidInPut: "a")
        shoulChangeCharactersIn(invalidInPut: "rupesh")
        shoulChangeCharactersIn(invalidInPut: "0.1234")
        shoulChangeCharactersIn(invalidInPut: "1234.1234")
    }

    func testShouldChangeCharacters_ValidInput() {
        shoulChangeCharactersIn(validInPut: "")
        shoulChangeCharactersIn(validInPut: "0")
        shoulChangeCharactersIn(validInPut: "1")
        shoulChangeCharactersIn(validInPut: "123")
        shoulChangeCharactersIn(validInPut: "123.")
        shoulChangeCharactersIn(validInPut: ".")
        shoulChangeCharactersIn(validInPut: "0.")
        shoulChangeCharactersIn(validInPut: "0.4")
        shoulChangeCharactersIn(validInPut: "0.45")
        shoulChangeCharactersIn(validInPut: "12.1")
        shoulChangeCharactersIn(validInPut: "12.12")
    }

    func shoulChangeCharactersIn(invalidInPut: String) {
        let isValid = presenter.shouldChangerCharacters(text: invalidInPut)
        XCTAssertFalse(isValid)
    }

    func shoulChangeCharactersIn(validInPut: String) {
        let isValid = presenter.shouldChangerCharacters(text: validInPut)
        XCTAssertTrue(isValid)
    }

    func testDidUpdateText_ForBaseCurrencyNil_NetworkAvailable() {
        checkNetworkAvailableBaseCurrencyNilTestCases(for: nil)
        checkNetworkAvailableBaseCurrencyNilTestCases(for: "0")
        checkNetworkAvailableBaseCurrencyNilTestCases(for: "1")
    }

    func checkNetworkAvailableBaseCurrencyNilTestCases(for text: String?) {
        setUp()
        mockBaseCurrencyManager.baseCurrency = nil
        mockNetworkMonitor.set(isNetworkAvailable: true)

        presenter.didUpdate(text: text)
        XCTAssertEqual(mockView.loadingState, .firstTime)
        XCTAssertTrue(mockInteractor.isConvertRatesTriggered)
        XCTAssertEqual(mockInteractor.currencyIdentifier, "")

        // Since status is In Progress Interactor and Router are not triggered
        mockView.loadingState = CurrencyConverterLoaderState.none
        mockInteractor.isConvertRatesTriggered = false
        mockInteractor.currencyIdentifier = nil
        presenter.didUpdate(text: text)
        XCTAssertEqual(mockView.loadingState, CurrencyConverterLoaderState.firstTime)
        XCTAssertFalse(mockInteractor.isConvertRatesTriggered)
        XCTAssertNil(mockInteractor.currencyIdentifier)
        tearDown()
    }

    func testDidUpdateText_ForBaseCurrencyNil_NetworkUnavailable() {
        checkNetworkUnavailableBaseCurrrencyNilTestCases(for: nil)
        checkNetworkUnavailableBaseCurrrencyNilTestCases(for: "0")
        checkNetworkUnavailableBaseCurrrencyNilTestCases(for: "1")
    }

    func checkNetworkUnavailableBaseCurrrencyNilTestCases(for text: String?) {
        setUp()
        mockNetworkMonitor.set(isNetworkAvailable: false)
        mockBaseCurrencyManager.baseCurrency = nil

        presenter.didUpdate(text: text)
        XCTAssertEqual(mockView.loadingState, .firstTime)
        XCTAssertTrue(mockRouter.isRetryControllerShown)

        // For network unavailable synchronisationStatus isSet To Synchronised
        mockView.loadingState = CurrencyConverterLoaderState.none
        mockInteractor.isConvertRatesTriggered = false
        mockInteractor.currencyIdentifier = nil
        presenter.didUpdate(text: text)
        XCTAssertEqual(mockView.loadingState, .firstTime)
        XCTAssertTrue(mockRouter.isRetryControllerShown)
        tearDown()
    }

    func testDidUpdateText_ForBaseCurrencyAvailable_NetworkAvailable(){
        // When contact status is synchronised
        checkNetworkAvailableBaseCurrencyAvailableTestCases(for: nil)
        checkNetworkAvailableBaseCurrencyAvailableTestCases(for: "0")
        checkNetworkAvailableBaseCurrencyAvailableTestCases(for: "1")

    }

    func checkNetworkAvailableBaseCurrencyAvailableTestCases(for text: String?) {
        setUp()
        let identifier = "USD"
        mockBaseCurrencyManager.baseCurrency = MockCurrency(identifier: identifier, multiplier: 1)
        mockNetworkMonitor.set(isNetworkAvailable: true)
        mockTimestampSynchroniser.isSynchronisationNeeded = true

        presenter.didUpdate(text: text)
        XCTAssertEqual(mockView.loadingState, CurrencyConverterLoaderState.none)
        XCTAssertTrue(mockInteractor.isConvertRatesTriggered)
        XCTAssertTrue(mockView.isDataReloaded)
        XCTAssertEqual(mockInteractor.currencyIdentifier, identifier)

        // Since status is In Progress Interactor and Router are not triggered
        mockView.loadingState = CurrencyConverterLoaderState.firstTime
        mockInteractor.isConvertRatesTriggered = false
        mockView.isDataReloaded = false
        mockInteractor.currencyIdentifier = nil
        presenter.didUpdate(text: text)
        XCTAssertEqual(mockView.loadingState, CurrencyConverterLoaderState.none)
        XCTAssertFalse(mockInteractor.isConvertRatesTriggered)
        XCTAssertNil(mockInteractor.currencyIdentifier)
        XCTAssertTrue(mockView.isDataReloaded)
        tearDown()
    }

    func testDidUpdateText_ForBaseCurrencyAvailable_NetworkUnAvailable(){
        // When contact status is synchronised
        checkNetworkUnavailableBaseCurrencyAvailableTestCases(for: nil)
        checkNetworkUnavailableBaseCurrencyAvailableTestCases(for: "0")
        checkNetworkUnavailableBaseCurrencyAvailableTestCases(for: "1")
    }

    func checkNetworkUnavailableBaseCurrencyAvailableTestCases(for text: String?) {
        setUp()
        let identifier = "USD"
        mockBaseCurrencyManager.baseCurrency = MockCurrency(identifier: identifier, multiplier: 1)
        mockNetworkMonitor.set(isNetworkAvailable: false)

        presenter.didUpdate(text: text)
        XCTAssertEqual(mockView.loadingState, CurrencyConverterLoaderState.none)
        XCTAssertFalse(mockInteractor.isConvertRatesTriggered)
        XCTAssertNil(mockInteractor.currencyIdentifier)

        // Since status is In Progress Interactor and Router are not triggered
        mockView.loadingState = CurrencyConverterLoaderState.firstTime
        mockInteractor.isConvertRatesTriggered = false
        mockView.isDataReloaded = false
        mockInteractor.currencyIdentifier = nil
        presenter.didUpdate(text: text)
        XCTAssertEqual(mockView.loadingState, CurrencyConverterLoaderState.none)
        XCTAssertFalse(mockInteractor.isConvertRatesTriggered)
        XCTAssertNil(mockInteractor.currencyIdentifier)
        XCTAssertTrue(mockView.isDataReloaded)
        tearDown()
    }

    func testDidUpdateText_SynchronisationFalse() {
        checkSynchronisationFalseTestCases(for: "0")
        checkSynchronisationFalseTestCases(for: "1")
        checkSynchronisationFalseTestCases(for: nil)
    }

    func checkSynchronisationFalseTestCases(for text: String?) {
        setUp()
        let identifier = "USD"
        mockBaseCurrencyManager.baseCurrency = MockCurrency(identifier: identifier, multiplier: 1)
        mockNetworkMonitor.set(isNetworkAvailable: false)

        presenter.didUpdate(text: text)
        XCTAssertEqual(mockView.loadingState, CurrencyConverterLoaderState.none)
        XCTAssertFalse(mockInteractor.isConvertRatesTriggered)
        XCTAssertNil(mockInteractor.currencyIdentifier)
        XCTAssertTrue(mockView.isDataReloaded)
        tearDown()
    }

    func testWhenNoBaseCurrencyIsAvailable_RowsShouldBeZero() {
        mockBaseCurrencyManager.baseCurrency = nil
        checkNumberOfRowsIsZero()
    }

    func testWhenNoCurrencyDataIsAvailable_RowsShouldBeZero() {
        mockCurrencyRepository.deleteAll()
        mockBaseCurrencyManager.baseCurrency = MockCurrency(identifier: "USD", multiplier: 1)
        checkNumberOfRowsIsZero()
    }

    func checkNumberOfRowsIsZero() {
        presenter.didUpdate(text: nil)
        XCTAssertEqual(presenter.numberOfRows, 0)

        presenter.didUpdate(text: "0")
        XCTAssertEqual(presenter.numberOfRows, 0)

        presenter.didUpdate(text: "1")
        XCTAssertEqual(presenter.numberOfRows, 0)
    }

    func testDataIsUpdatedOnTextUpdate() {
        checkUpdateCurrencyValuesForSingleRow(with: nil)
        checkUpdateCurrencyValuesForSingleRow(with: "0")
        checkUpdateCurrencyValuesForSingleRow(with: "1")
        checkUpdateCurrencyValuesForSingleRow(with: "1.2")
        checkUpdateCurrencyValuesForSingleRow(with: ".2")
        checkUpdateCurrencyValuesForSingleRow(with: "0.2")
        
        checkUpdateCurrencyValuesForMultipleRow(with: nil)
        checkUpdateCurrencyValuesForMultipleRow(with: "0")
        checkUpdateCurrencyValuesForMultipleRow(with: "1")
        checkUpdateCurrencyValuesForMultipleRow(with: "1.2")
        checkUpdateCurrencyValuesForMultipleRow(with: ".2")
        checkUpdateCurrencyValuesForMultipleRow(with: "0.2")
    }

    func checkUpdateCurrencyValuesForMultipleRow(with text: String?) {
        setUp()
        let currencyFormatter = CurrencyFormatter(maximumFractionDigits: 2)
        presenter = CurrencyConverterPresenter(
            interactor: mockInteractor,
            router: mockRouter,
            baseCurrencyManager: mockBaseCurrencyManager,
            currencyRepository: mockCurrencyRepository,
            timestampSynchroniser: mockTimestampSynchroniser,
            currencyFormatter: currencyFormatter,
            networkMonitor: mockNetworkMonitor,
            coreDataUpdateHandler: mockCoreDataUpdateHandler
        )
        presenter.view = mockView

        let currency = MockCurrency(identifier: "USD", multiplier: 1)
        let currencies = [currency,
                          MockCurrency(identifier: "INR", multiplier: 56),
                          MockCurrency(identifier: "JPY", multiplier: 120)]
        mockCurrencyRepository.create(currencies: currencies)
        mockBaseCurrencyManager.baseCurrency = currency
        let inputAmount = ((text ?? "") as NSString).doubleValue
        presenter.didUpdate(text: text)
        XCTAssertEqual(presenter.numberOfRows, 3)
        checkRowData(for: IndexPath(row: 0, section: 0), currency: currencies[0], currencyFormatter: currencyFormatter, inputAmount: inputAmount)
        checkRowData(for: IndexPath(row: 1, section: 0), currency: currencies[1], currencyFormatter: currencyFormatter, inputAmount: inputAmount)
        checkRowData(for: IndexPath(row: 2, section: 0), currency: currencies[2], currencyFormatter: currencyFormatter, inputAmount: inputAmount)

        tearDown()
    }

    func checkRowData(for indexPath: IndexPath, currency: CurrencyProtocol, currencyFormatter: CurrencyFormatterProtocol, inputAmount: Double) {
        XCTAssertEqual(presenter.getRowData(for: indexPath).value, currencyFormatter.getFormattedString(for: currency.multiplier * inputAmount))
        XCTAssertEqual(presenter.getRowData(for: indexPath).key, currency.identifier)
    }

    func checkUpdateCurrencyValuesForSingleRow(with text: String?) {
        setUp()
        let currencyFormatter = CurrencyFormatter(maximumFractionDigits: 2)
        presenter = CurrencyConverterPresenter(
            interactor: mockInteractor,
            router: mockRouter,
            baseCurrencyManager: mockBaseCurrencyManager,
            currencyRepository: mockCurrencyRepository,
            timestampSynchroniser: mockTimestampSynchroniser,
            currencyFormatter: currencyFormatter,
            networkMonitor: mockNetworkMonitor,
            coreDataUpdateHandler: mockCoreDataUpdateHandler
        )
        presenter.view = mockView

        let currency = MockCurrency(identifier: "USD", multiplier: 1)
        mockCurrencyRepository.create(currency: currency)
        mockBaseCurrencyManager.baseCurrency = currency
        let inputAmount = ((text ?? "") as NSString).doubleValue
        presenter.didUpdate(text: text)
        XCTAssertEqual(presenter.numberOfRows, 1)
        XCTAssertEqual(presenter.getRowData(for: IndexPath(row: 0, section: 0)).value, currencyFormatter.getFormattedString(for: currency.multiplier * inputAmount))
        XCTAssertEqual(presenter.getRowData(for: IndexPath(row: 0, section: 0)).key, currency.identifier)
        tearDown()
    }

    func testDidPressCurrencyChange() {
        presenter.didPressCurrencyChange()
        XCTAssertTrue(mockRouter.isNavigatedToBaseCurrencySelection)
        XCTAssertNotNil(mockRouter.currencySelectiondelegate)
    }

    func testWhenBaseCurrencyIsNilRetry() {
        let identifier = "INR"
        presenter.didFetch(currencyRates: CurrencyRatesResponse(base: identifier, rates: [identifier: 0]))
        XCTAssertEqual(mockView.loadingState, .firstTime)
        XCTAssertTrue(mockInteractor.isConvertRatesTriggered)
        XCTAssertEqual(mockInteractor.currencyIdentifier, identifier)
    }
}
