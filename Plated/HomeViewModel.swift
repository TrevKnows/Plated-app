//
//  HomeViewModel.swift
//  Plated
//
//  Created by Trevor Beaton on 11/17/24.
//

import Foundation
import SwiftUI


class HomeViewModel: ObservableObject {
    @Published var recipesLoaded: [Recipe] = []
    @Published var isLoading = false
    @Published var error: Error?

    private let networkManager: NetworkManaging

    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }

    @MainActor
    func fetchRecipes(endpoint: RecipeAPI) async throws{
        do {
            let recipes = try await networkManager.fetchData(for: endpoint, responseType: [Recipe].self)
            self.recipesLoaded = recipes

        } catch let error as APIError {
            self.error = error
            print("API Error: \(error.localizedDescription)")
            throw error

        } catch {
            let genericError = APIError.decodingError
            self.error = genericError
            print("Unknown Error: \(error.localizedDescription)")
            throw genericError
        }
    }
}
