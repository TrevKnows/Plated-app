//
//  Recipe.swift
//  Plated
//
//  Created by Trevor Beaton on 11/17/24.
//

import Foundation

struct Recipe: Codable, Equatable, Identifiable, Hashable {
    var id: String { uuid }
    let uuid: String
    let name: String
    let cuisine: String
    let photoUrlSmall: String?
    let photoUrlLarge: String?
    let sourceUrl: String?
    let youtubeUrl: String?

    enum CodingKeys: String, CodingKey {
        case uuid
        case name
        case cuisine
        case photoUrlSmall = "photo_url_small"
        case photoUrlLarge = "photo_url_large"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}
