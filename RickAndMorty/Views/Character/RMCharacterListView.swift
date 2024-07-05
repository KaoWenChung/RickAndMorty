//
//  RMCharacterListView.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/06/2024.
//

import UIKit

// View that handles showing list of characters, loader, etc.
// MARK: - View Implementation
final class RMCharacterListView: UIView, RMCharacterListViewProtocol {

    weak var delegate: RMCharacterListViewDelegate?

    private let viewModel: RMCharacterListViewViewModelProtocol
    private let collectionHandler: RMCharacterListViewCollectionHandler

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true

        return spinner
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.register(
            RMCharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier
        )
        collectionView.register(
            RMFooterLoadingCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier
        )

        return collectionView
    }()

    // MARK: - Init
    init(viewModel: RMCharacterListViewViewModelProtocol) {
        self.viewModel = viewModel
        self.collectionHandler = RMCharacterListViewCollectionHandler(viewModel: viewModel)

        super.init(frame: .zero)

        setupView()
        addObservers()
        setupViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeObservers()
    }
}

// MARK: - SetupMethods
extension RMCharacterListView {
    private func setupView() {
        backgroundColor = .systemBackground

        addSubviews(collectionView, spinner)
        setupSubviews()

        addConstraints()
    }

    private func setupSubviews() {
        spinner.startAnimating()
        setupCollectionView()
    }

    private func setupCollectionView() {
        collectionView.dataSource = collectionHandler
        collectionView.delegate = collectionHandler
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(orientationDidChange),
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIDevice.orientationDidChangeNotification,
            object: nil
        )
    }

    // MARK: - SetupViewModel
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.fetchCharacters()
    }
}

// MARK: - PublicMethods
extension RMCharacterListView {
    func setNilValueForScrollOffset() {
        collectionView.setContentOffset(.zero, animated: true)
    }

    @objc
    func orientationDidChange(_ notification: Notification) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: - RMCharacterListViewViewModelDelegate
extension RMCharacterListView: RMCharacterListViewViewModelDelegate {
    func didSelectCharacter(_ character: RMCharacter) {
        delegate?.rmCharacterListView(self, didSelectCharacter: character)
    }

    func didLoadInitialCharacters() {
        self.spinner.stopAnimating()
        self.collectionView.isHidden = false
        collectionView.reloadData() // Initial fetch of characters
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }

    func didLoadMoreCharacters(with newIndexPath: [IndexPath]) {
        collectionView.performBatchUpdates { [weak self] in
            self?.collectionView.insertItems(at: newIndexPath)
        }
    }
}

// MARK: - Constraints
extension RMCharacterListView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),

            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
