//
//  SelectCurrencyPresenterTests.swift
//  CurrencyConverterTests
//
//  Created by Rupeshkumar on 03/07/23.
//

import XCTest
@testable import CurrencyConverter

final class SelectCurrencyPresenterTests: XCTestCase {

    var presenter: SelectCurrencyPresenter!
    var mockRouter: MockRouter!
    var mockBaseCurrencyManager: MockBaseCurrencyManager!
    var mockCurrencyRepository: MockCurrencyRepository!
    var mockDelegate: MockSelectCurrencyDelegate!
    var mockView: MockSelectCurrencyView!

    override func setUp() {
        super.setUp()

        mockRouter = MockRouter()
        mockBaseCurrencyManager = MockBaseCurrencyManager()
        mockCurrencyRepository = MockCurrencyRepository()
        mockDelegate = MockSelectCurrencyDelegate()
        mockView = MockSelectCurrencyView()

        presenter = SelectCurrencyPresenter(router: mockRouter,
                                            baseCurrencyManager: mockBaseCurrencyManager,
                                            currencyRepository: mockCurrencyRepository,
                                            delegate: mockDelegate)
        presenter.view = mockView
    }

    override func tearDown() {
        super.tearDown()

        mockRouter = nil
        mockBaseCurrencyManager = nil
        mockCurrencyRepository = nil
        mockDelegate = nil
        mockView = nil
        presenter = nil
    }

    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertTrue(mockView.isReloadDataTriggered)
    }

    func backButtonPressed() {
        presenter.backButtonPressed()
        XCTAssertTrue(mockRouter.isPopSelectionViewTriggered)
    }

    func testDidSearchForText() {
        presenter.didSearch(for: "")
        XCTAssertTrue(mockView.isReloadDataTriggered)
    }

    func testDidSearchForTextReloadData() {

        let usdCurrency = MockCurrency(identifier: "USD", multiplier: 1)
        let currencies: [MockCurrency] = [usdCurrency,
                                          .init(identifier: "JPY", multiplier: 144.34),
                                          .init(identifier: "INR", multiplier: 82.1)].sorted(by: {$0.identifier < $1.identifier})
        mockCurrencyRepository.create(currencies: currencies)
        mockBaseCurrencyManager.saveBaseCurrency(currency: usdCurrency)

        presenter = SelectCurrencyPresenter(router: mockRouter,
                                            baseCurrencyManager: mockBaseCurrencyManager,
                                            currencyRepository: mockCurrencyRepository,
                                            delegate: mockDelegate)
        presenter.view = mockView

        presenter.didSearch(for: "")
        XCTAssertTrue(mockView.isReloadDataTriggered)
        XCTAssertEqual(presenter.numberOfRows, 3)

        let viewModel1 = presenter.cellForRow(at: IndexPath(row: 0, section: 0))
        let viewModel2 = presenter.cellForRow(at: IndexPath(row: 1, section: 0))
        let viewModel3 = presenter.cellForRow(at: IndexPath(row: 2, section: 0))

        XCTAssertEqual(currencies[0].identifier, viewModel1.text)
        XCTAssertEqual(viewModel1.cellState, SelectCurrencyCellState.none)
        XCTAssertEqual(currencies[1].identifier, viewModel2.text)
        XCTAssertEqual(viewModel2.cellState, SelectCurrencyCellState.none)
        XCTAssertEqual(currencies[2].identifier, viewModel3.text)
        XCTAssertEqual(viewModel3.cellState, SelectCurrencyCellState.currentBase)

        checkRepositoryCheck(for: currencies, with: "US", usdCurrency: usdCurrency)
        checkRepositoryCheck(for: currencies, with: "us", usdCurrency: usdCurrency)
        checkRepositoryCheck(for: currencies, with: "uS", usdCurrency: usdCurrency)
        checkRepositoryCheck(for: currencies, with: "Us", usdCurrency: usdCurrency)
    }

    func checkRepositoryCheck(for currencies: [CurrencyProtocol], with text: String, usdCurrency: CurrencyProtocol) {

        mockCurrencyRepository.deleteAll()
        mockCurrencyRepository.create(currencies: currencies)
        presenter.didSearch(for: text)
        let firstSearchResult = presenter.cellForRow(at: IndexPath(row: 0, section: 0))

        XCTAssertTrue(mockView.isReloadDataTriggered)
        XCTAssertEqual(presenter.numberOfRows, 1)
        XCTAssertEqual(usdCurrency.identifier, firstSearchResult.text)
        XCTAssertEqual(firstSearchResult.cellState, SelectCurrencyCellState.currentBase)
    }

    func testDidSelectRow_WhenBaseCurrencyIsDifferent_BaseCurrencyGetsUpdated() {
        setPresenterWithCurrencies()
        presenter.didSelectRow(at: IndexPath(row: 0, section: 0))
        XCTAssertEqual(mockBaseCurrencyManager.getBaseCurrency()?.identifier, "INR")
        XCTAssertTrue(mockRouter.isPopSelectionViewTriggered)
        XCTAssertTrue(mockDelegate.isDidUpdateBaseCurrencTriggered)
    }

    func testDidSelectRow_WhenBaseCurrencyIsSame_BaseCurrencyDoesNotGetsUpdated() {
        setPresenterWithCurrencies()
        presenter.didSelectRow(at: IndexPath(row: 2, section: 0))
        XCTAssertEqual(mockBaseCurrencyManager.getBaseCurrency()?.identifier, "USD")
        XCTAssertFalse(mockRouter.isPopSelectionViewTriggered)
        XCTAssertFalse(mockDelegate.isDidUpdateBaseCurrencTriggered)
    }

    func setPresenterWithCurrencies() {
        let usdCurrency = MockCurrency(identifier: "USD", multiplier: 1)
        let currencies: [MockCurrency] = [usdCurrency,
                                          .init(identifier: "JPY", multiplier: 144.34),
                                          .init(identifier: "INR", multiplier: 82.1)].sorted(by: {$0.identifier < $1.identifier})
        mockCurrencyRepository.create(currencies: currencies)
        mockBaseCurrencyManager.saveBaseCurrency(currency: usdCurrency)

        presenter = SelectCurrencyPresenter(router: mockRouter,
                                            baseCurrencyManager: mockBaseCurrencyManager,
                                            currencyRepository: mockCurrencyRepository,
                                            delegate: mockDelegate)
        presenter.view = mockView
    }
    
}
