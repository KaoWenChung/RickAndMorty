//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 03/06/2024.
//

import UIKit

// Controller to show and search for Locations
final class RMLocationViewController: UIViewController {

    private let locationView = RMLocationView()

    private let viewModel = RMLocationViewViewModel()

    // MARK: - DeInit
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = locationView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupController()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateNavigationBar()
        }
    }
}

// MARK: - Setup
extension RMLocationViewController {
    private func setupController() {
        title = "Locations"
        addSearchButton()
        addChangeThemeButton()

        locationView.delegate = self
        viewModel.delegate = self

        viewModel.fetchLocations()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tabBarItemDoubleTapped),
            name: .tabBarItemDoubleTapped,
            object: nil
        )
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }

    private func addChangeThemeButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "lightbulb"),
            style: .plain,
            target: self,
            action: #selector(didTapChangeTheme)
        )
    }

    private func updateNavigationBar() {
        let isDarkMode = (self.traitCollection.userInterfaceStyle == .dark)
        let iconName = isDarkMode ? "lightbulb" : "lightbulb.fill"
        navigationItem.leftBarButtonItem?.image = UIImage(systemName: iconName)
    }
}

// MARK: - ActionMethods
extension RMLocationViewController {
    @objc
    private func didTapSearch() {
        let viewController = RMSearchViewController(config: .init(type: .location))
        viewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(viewController, animated: true)
    }

    @objc
    private func didTapChangeTheme() {
        RMThemeManager.shared.toggleTheme()
    }

    @objc
    private func tabBarItemDoubleTapped(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let viewController = userInfo["viewController"] as? UIViewController else {
            return
        }

        if viewController == self {
            locationView.setNilValueForScrollOffset()
        }
    }
}

// MARK: - RMLocationViewDelegate
extension RMLocationViewController: RMLocationViewDelegate {
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let viewController = RMLocationDetailsViewController(location: location)
        viewController.navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - RMLocationViewViewModelDelegate
extension RMLocationViewController: RMLocationViewViewModelDelegate {
    func didFetchInitialLocations() {
        locationView.configure(with: viewModel)
    }
}
