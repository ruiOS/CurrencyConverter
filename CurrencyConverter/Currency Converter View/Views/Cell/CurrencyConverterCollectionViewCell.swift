//
//  CurrencyConverterCollectionViewCell.swift
//  CurrencyConverter
//
//  Created by Rupeshkumar on 01/07/23.
//

import UIKit
final class CurrencyConverterCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    let keyLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let spacing: CGFloat = 8

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private
private extension CurrencyConverterCollectionViewCell {

    func setUpViews() {
        setShadow()
        addSubview(keyLabel)
        NSLayoutConstraint.activate([
            keyLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: spacing),
            keyLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            keyLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -spacing),
        ])

        addSubview(valueLabel)
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: keyLabel.bottomAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -spacing),
            valueLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: spacing),
            valueLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -spacing)
        ])
    }

    func setShadow() {
        let radius: CGFloat = 10
        let opacity: Float = 0.2
        backgroundColor = .systemGray
        clipsToBounds = false
        backgroundColor = .systemBackground
        layer.cornerRadius = radius
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.borderWidth = 1
        layer.borderColor = UIColor.separator.cgColor
    }
}

// MARK: - Internal
extension CurrencyConverterCollectionViewCell {

    func setUpCell(with viewModel: CurrencyConverterCellVMProtocol) {
        keyLabel.text = viewModel.key
        valueLabel.text = viewModel.value
    }
}
