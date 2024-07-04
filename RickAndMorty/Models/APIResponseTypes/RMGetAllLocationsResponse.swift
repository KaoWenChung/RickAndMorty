//
//  RMGetLocationsResponse.swift
//  RickAndMorty
//
//  Created by Andrei Shpartou on 05/06/2024.
//

import Foundation

struct RMGetAllLocationsResponse: Codable {

    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [RMLocation]
}
