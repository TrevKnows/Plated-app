//
//  Recipe.swift
//  Plated
//
//  Created by Trevor Beaton on 11/17/24.
//

// Payload
//{
//    "recipes": [
//        {
//            "cuisine": "British",
//            "name": "Bakewell Tart",
//            "photo_url_large": "https://some.url/large.jpg",
//            "photo_url_small": "https://some.url/small.jpg",
//            "uuid": "eed6005f-f8c8-451f-98d0-4088e2b40eb6",
//            "source_url": "https://some.url/index.html",
//            "youtube_url": "https://www.youtube.com/watch?v=some.id"
//        },
//        ...
//    ]
//}

import Foundation

struct Recipe: Codable, Equatable, Identifiable {
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
        case cuisine
        case name
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
    
}
