//
//  SelectCurrencyViewController.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 01/07/23.
//  
//
import UIKit

// MARK: - SelectCurrencyViewable
protocol SelectCurrencyViewable: AnyObject {
    func reloadData()
}

// MARK: - SelectCurrencyViewController
final class SelectCurrencyViewController: UIViewController {

    // MARK: Properties
    private let presenter: SelectCurrencyPresentable
    private let cellIdentifier = "Cell"

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = AppStrings.searchCurrencies
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.keyboardDismissMode = .onDrag
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    // MARK: Lifecycle
    init(presenter: SelectCurrencyPresentable) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        view.backgroundColor = .systemBackground
        presenter.viewDidLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: SelectCurrencyViewable
extension SelectCurrencyViewController: SelectCurrencyViewable {

    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: Private
private extension SelectCurrencyViewController {

    func setUpViews() {
        view.addSubview(searchBar)
        searchBar.searchBarStyle = .minimal
        searchBar.barTintColor = .systemBackground
        searchBar.delegate = self
        searchBar.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor)
        ])
    }

    @objc func backButtonPressed() {
        presenter.backButtonPressed()
    }
}

// MARK: UITableViewDataSource
extension SelectCurrencyViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        var config = UIListContentConfiguration.cell()
        let viewModel = presenter.cellForRow(at: indexPath)
        config.text = viewModel.text
        config.textProperties.font = .boldSystemFont(ofSize: 16)
        config.textProperties.color = viewModel.cellState == .currentBase ? .systemBlue : .label
        cell.contentConfiguration = config
        cell.backgroundColor = .systemBackground
        return cell
    }
}

// MARK: UITableViewDelegate
extension SelectCurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
        presenter.didSelectRow(at: indexPath)
    }
}

// MARK: UISearchBarDelegate
extension SelectCurrencyViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.didSearch(for: searchText)
    }
}
