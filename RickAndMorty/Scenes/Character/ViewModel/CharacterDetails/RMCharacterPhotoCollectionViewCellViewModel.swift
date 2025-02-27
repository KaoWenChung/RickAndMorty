//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 08/06/2024.
//

import Foundation

// MARK: - ViewModelImplementation
// ViewModel for the character photo collection view cell
final class RMCharacterPhotoCollectionViewCellViewModel: RMCharacterPhotoCollectionViewCellViewModelProtocol {

    private let imageURL: URL?
    private let imageLoader: RMImageLoaderProtocol

    init(
        imageURL: URL?,
        imageLoader: RMImageLoaderProtocol = RMImageLoader.shared
    ) {
        self.imageURL = imageURL
        self.imageLoader = imageLoader
    }

    func fetchImage(completion: @escaping (Result<Data, Error>, URL?) -> Void) {
        guard let imageURL = imageURL else {
            completion(.failure(RMServiceError.invalidURL), nil)
            return
        }

        imageLoader.downloadImage(imageURL, completion: completion)
    }
}
