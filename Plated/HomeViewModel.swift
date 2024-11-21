//
//  HomeViewModel.swift
//  Plated
//
//  Created by Trevor Beaton on 11/17/24.
//

import Foundation
import SwiftUI


class HomeViewModel: ObservableObject {
    @Published private(set) var state: RecipeListState = .loading
    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }

    @MainActor
    func fetchRecipes(endpoint: RecipeAPI) async throws {
        state = .loading
        
        do {
            let recipes = try await networkManager.fetchData(for: endpoint, responseType: [Recipe].self)
            state = recipes.isEmpty ? .empty : .loaded(recipes)
        } catch let error as APIError {
            state = .error(error)
            throw error
        } catch {
            let genericError = APIError.decodingError
            state = .error(genericError)
            throw genericError
        }
    }
}
