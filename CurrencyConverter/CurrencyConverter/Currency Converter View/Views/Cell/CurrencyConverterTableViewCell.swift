
import UIKit

final class CurrencyConverterTableViewCell: UITableViewCell {

    // MARK: - Properties
    let keyLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let spacing: CGFloat = 8

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        keyLabel.text = nil
        valueLabel.text = nil
    }

    // MARK: - Private
    private func setUpViews() {
        contentView.addSubview(keyLabel)
        contentView.addSubview(valueLabel)
        NSLayoutConstraint.activate([
            keyLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            keyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            keyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),

            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),
            valueLabel.leadingAnchor.constraint(equalTo: keyLabel.trailingAnchor, constant: spacing)
        ])
    }

    // MARK: - Internal
    func setUpCell(with viewModel: CurrencyConverterCellVMProtocol) {
        keyLabel.text = viewModel.key
        valueLabel.text = viewModel.value
    }
}