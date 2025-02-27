//
//  RMNoSearchResultsView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/06/2024.
//

import UIKit

final class RMNoSearchResultsView: UIView {

    private let viewModel = RMNoSearchResultsViewViewModel()

    private lazy var iconView: UIImageView = createIconImageView()
    private let label: UILabel = .createLabel(fontSize: 20, weight: .medium, textAlignment: .center)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup
extension RMNoSearchResultsView {
    private func setupView() {
        isHidden = true
        addSubviews(iconView, label)
        configure()

        addConstraints()
    }

    private func configure() {
        label.text = viewModel.title
        iconView.image = viewModel.image
    }
}

// MARK: - Helpers
extension RMNoSearchResultsView {
    private func createIconImageView() -> UIImageView {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemBlue

        return iconView
    }
}

// MARK: - Constraints
extension RMNoSearchResultsView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 90),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.heightAnchor.constraint(equalToConstant: 90),

            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
