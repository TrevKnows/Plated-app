//
//  API.swift
//  Plated
//
//  Created by Trevor Beaton on 11/17/24.
//

import Foundation

enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

enum HTTPScheme: String {
    case http
    case https
}

protocol API {
    var scheme: HTTPScheme { get }
    var baseURL: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var method: HTTPMethod { get }
}

enum RecipeAPI: API {
    case fetchAllRecipes
    case fetchRecipesFromCustomURL(String)
    
    var scheme: HTTPScheme {
        return .https
    }
    
    var baseURL: String {
        switch self {
        case .fetchAllRecipes, .fetchRecipesFromCustomURL:
            return "d3jbb8n5wk0qxi.cloudfront.net"
        }
    }

    var path: String {
        switch self {
        case .fetchAllRecipes:
            return "/recipes.json"
        case .fetchRecipesFromCustomURL(let customPath):
            return customPath
        }
    }

    var parameters: [URLQueryItem] {
        return []
    }

    var method: HTTPMethod {
        return .get
    }
}
