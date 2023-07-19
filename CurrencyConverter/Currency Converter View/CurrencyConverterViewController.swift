//
//  CurrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 29/06/23.
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

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let padding: CGFloat = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.keyboardDismissMode = .onDrag
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.contentInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        return collectionView
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
        setupCollectionView(with: widthMultiplier)
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

    func setupCollectionView(with widthMultiplier: CGFloat) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CurrencyConverterCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: currencyInputView.bottomAnchor, constant: 20),
            collectionView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: widthMultiplier),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
        collectionView.isHidden = true
        currencyInputView.isHidden = true
    }

    func dismissLoadingState() {
        view.isUserInteractionEnabled = true
        loader.stopAnimating()
        collectionView.isHidden = false
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
            self?.collectionView.reloadData()
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

// MARK: UICollectionViewDataSource
extension CurrencyConverterViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfRows
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: CurrencyConverterCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CurrencyConverterCollectionViewCell else {
            return UICollectionViewCell(frame: .zero)
        }
        cell.setUpCell(with: presenter.getRowData(for: indexPath))
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CurrencyConverterViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 40)/3
        return CGSize(width: width, height: width)
    }
}
