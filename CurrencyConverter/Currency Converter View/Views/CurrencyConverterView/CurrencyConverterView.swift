//
//  CurrencyConverterView.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 30/06/23.
//

import UIKit

// MARK: - CurrencyConverterViewDelegate
protocol CurrencyConverterViewDelegate: AnyObject {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool
    func didPressButton()
    func didUpdateTextField(with text: String?)
}

// MARK: - CurrencyConverterView
final class CurrencyConverterView: UIView {

    // MARK: Properties
    private let textField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .decimalPad
        textField.backgroundColor = .systemBackground
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemBlue

        let image = UIImage(named: "drop_down")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.tintColor = .label

        let spacing: CGFloat = 5
        let padding: CGFloat = 8
        var configuration = UIButton.Configuration.tinted()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
        configuration.imagePadding = spacing
        configuration.titlePadding = spacing
        button.configuration = configuration

        button.semanticContentAttribute = .forceRightToLeft
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()

    weak var delegate: CurrencyConverterViewDelegate?
    private var viewModel: CurrencyConverterViewModel = .init(buttonText: "", inputText: "")

    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 1
    }
}

extension CurrencyConverterView {
    func setView(with viewModel: CurrencyConverterViewModel) {
        let inputText = viewModel.inputText
        textField.text = inputText
        delegate?.didUpdateTextField(with: inputText)
        button.setTitle(viewModel.buttonText, for: .normal)
    }
}

// MARK: Private
private extension CurrencyConverterView {

    func setUpViews() {
        addSubview(button)
        button.setTitle(viewModel.buttonText, for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.heightAnchor.constraint(equalTo: heightAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        textField.delegate = self
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalTo: heightAnchor),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    @objc func didPressButton() {
        delegate?.didPressButton()
    }
}

// MARK: UITextFieldDelegate
extension CurrencyConverterView: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        delegate?.textField(textField,
                            shouldChangeCharactersIn: range,
                            replacementString: string) ?? false
    }
}
