//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 09/06/2024.
//

import UIKit

// Dynamic search option view
// Render results
// Render no results zero state
// Searching / API

/// Configurable controller to search
final class RMSearchViewController: UIViewController {

    private let searchView: RMSearchView
    private let viewModel: RMSearchViewViewModel
    
    // MARK: - ConfigProperties
    struct Config {
        enum ConfigType {
            case character // name, status, gender
            case episode // name
            case location // name | type
            
            var title: String {
                switch self {
                case .character:
                    return "Search Character"
                case .episode:
                    return "Search Episode"
                case .location:
                    return "Search Location"
                }
            }
        }
        
        let type: ConfigType
    }
    
    // MARK: - Init
    init(config: Config) {
        let viewModel = RMSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = RMSearchView(
            frame: .zero,
            viewModel: viewModel
        )
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        configureController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchView.presentKeyboard()
    }
    
    private func configureController() {
        title = viewModel.config.type.title
        
        searchView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Search",
            style: .done,
            target: self,
            action: #selector(didTapExecuteSearch))
    }
    
    // MARK: - ActionMethods
    @objc
    private func didTapExecuteSearch() {
        viewModel.executeSearch()
    }

}

// MARK: - RMSearchViewDelegate
extension RMSearchViewController: RMSearchViewDelegate {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        let viewController = RMSearchOptionPickerViewController(option: option) { [weak self] selection in
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
        }
        viewController.sheetPresentationController?.detents = [.medium()]
        viewController.sheetPresentationController?.prefersGrabberVisible = true
        present(viewController, animated: true)
    }
}
