//
//  RMSearchInputViewViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 13/06/2024.
//

import Foundation

final class RMSearchInputViewViewModel {

    enum DynamicOption: String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"

        var queryArgument: String {
            switch self {
            case .status:
                return "status"
            case .gender:
                return "gender"
            case .locationType:
                return "type"
            }
        }

        var choices: [String] {
            switch self {
            case .status:
                return ["alive", "dead", "unknown"]
            case .gender:
                return ["male", "female", "genderless", "unknown"]
            case .locationType:
                return ["cluster", "planet", "microverse"]
            }
        }
    }

    // MARK: - PublicProperties
    var hasDynamicOptions: Bool {
        switch type {
        case .character, .location:
            return true
        case .episode:
            return false
        }
    }

    var options: [DynamicOption] {
        switch type {
        case .character:
            return [.status, .gender]
        case .location:
            return [.locationType]
        case .episode:
            return []
        }
    }

    var searchPlaceHolderText: String {
        switch type {
        case .character:
            return "Character Name"
        case .location:
            return "Location Name"
        case .episode:
            return "Episode Title"
        }
    }

    // MARK: - PrivateProperties
    private let type: RMSearchViewController.Config.ConfigType

    // MARK: - Init
    init(type: RMSearchViewController.Config.ConfigType) {
        self.type = type
    }
}
