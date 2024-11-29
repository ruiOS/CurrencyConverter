//
//  CurrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by OwaishKalim on 29/06/23.
//  
//
import UIKit

// MARK: - CurrencyConverterViewable
protocol CurrencyConverterViewable: AnyObject {
    func reloadData()
    func setTextBar(with viewModel: CurrencyConverterViewModel)
    func setLoadingState(for loadingState: CurrencyConverterLoaderState)
}

// MARK: - CurrencyConverterLoaderState
enum CurrencyConverterLoaderState {
    case firstTime
    case none
}

// MARK: - CurrencyConverterViewController
final class CurrencyConverterViewController: UIViewController {

    private let presenter: CurrencyConverterPresentable
    private let cellIdentifier = "Cell"

    private let currencyInputView: CurrencyConverterView = {
        let textField = CurrencyConverterView(frame: .zero)
        textField.backgroundColor = .systemBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.keyboardDismissMode = .onDrag
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isScrollEnabled = true
        tableView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return tableView
    }()

    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .large)
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()

    // MARK: Lifecycle
    init(presenter: CurrencyConverterPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        presenter.viewDidLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension CurrencyConverterViewController {

    func setUpViews() {
        self.view.backgroundColor = .systemBackground
        title = AppStrings.currencyConverterTitle
        let widthMultiplier: CGFloat = 0.8
        setupCurrencyInputView(with: widthMultiplier)
        setupTableView(with: widthMultiplier)
        setUpLoader()
    }

    func setupCurrencyInputView(with widthMultiplier: CGFloat) {
        currencyInputView.delegate = self
        view.addSubview(currencyInputView)
        NSLayoutConstraint.activate([
            currencyInputView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currencyInputView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: widthMultiplier),
            currencyInputView.heightAnchor.constraint(equalToConstant: 40),
            currencyInputView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func setupTableView(with widthMultiplier: CGFloat) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CurrencyConverterTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: currencyInputView.bottomAnchor, constant: 20),
            tableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: widthMultiplier),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100)
        ])
    }

    func setUpLoader() {
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func showFirstTimeLoadingState() {
        loader.startAnimating()
        tableView.isHidden = true
        currencyInputView.isHidden = true
    }

    func dismissLoadingState() {
        view.isUserInteractionEnabled = true
        loader.stopAnimating()
        tableView.isHidden = false
        currencyInputView.isHidden = false
    }
}

// MARK: CurrencyConverterViewDelegate
extension CurrencyConverterViewController: CurrencyConverterViewDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let textFieldString = currentString.replacingCharacters(in: range, with: string)
        guard presenter.shouldChangerCharacters(text: textFieldString) else { return false }
        presenter.didUpdate(text: textFieldString)
        return true
    }

    func didPressButton() {
        view.endEditing(true)
        presenter.didPressCurrencyChange()
    }

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

// MARK: CurrencyConverterViewable
extension CurrencyConverterViewController: CurrencyConverterViewable {

    func setLoadingState(for loadingState: CurrencyConverterLoaderState) {
        DispatchQueue.main.async { [weak self] in
            switch loadingState {
            case .firstTime:
                self?.showFirstTimeLoadingState()
            case .none:
                self?.dismissLoadingState()
            }
        }
    }

    func setTextBar(with viewModel: CurrencyConverterViewModel) {
        DispatchQueue.main.async { [weak self] in
            self?.currencyInputView.setView(with: viewModel)
        }
    }

    func didUpdateTextField(with text: String?) {
        presenter.didUpdate(text: text)
    }
}

// MARK: UITableViewDataSource
extension CurrencyConverterViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: CurrencyConverterTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CurrencyConverterTableViewCell else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        cell.setUpCell(with: presenter.getRowData(for: indexPath))
        return cell
    }
}

// MARK: UITableViewDelegate
extension CurrencyConverterViewController: UITableViewDelegate {
    // Implement any UITableViewDelegate methods if needed
}
