//
//  API.swift
//  Plated
//
//  Created by Trevor Beaton on 11/17/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
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
    case malformedData
    case emptyData
    case fetchRecipesFromCustomURL(String)
    
    var scheme: HTTPScheme {
        return .https
    }
    
    var baseURL: String {
        switch self {
        case .fetchAllRecipes, .fetchRecipesFromCustomURL, .malformedData, .emptyData:
            return EndpointConstants.baseUrl
        }
    }
    
    var path: String {
        switch self {
        case .fetchAllRecipes:
            return "/recipes.json"
        case .malformedData:
            return "/recipes-malformed.json"
        case .emptyData:
            return "/recipes-empty.json"
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

