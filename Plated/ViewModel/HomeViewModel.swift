//
//  HomeViewModel.swift
//  Plated
//
//  Created by Trevor Beaton on 11/17/24.
//

import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var isLoading = false
    @Published private(set) var state: RecipeListState = .loading
    @Published var searchText = "" {
        didSet {
            updateState()
        }
    }
  
    private let networkManager: NetworkManaging
    private var allRecipes: [Recipe] = []

    init(networkManager: NetworkManaging = NetworkManager()) {
         self.networkManager = networkManager
     }

     @MainActor
     func fetchRecipes(endpoint: RecipeAPI) async throws {
         isLoading = true
         state = .loading

         do {
             
             let recipes = try await networkManager.fetchData(for: endpoint, responseType: [Recipe].self)
             allRecipes = recipes
             updateState()
         } catch let decodingError as DecodingError {

             state = .error(decodingError)
             allRecipes = []
             throw decodingError
         } catch {

             state = .error(error)
             throw error
         }

         isLoading = false
     }

    private func updateState() {
        let recipesToShow = RecipeFilter.filter(recipes: allRecipes, with: searchText)
        state = recipesToShow.isEmpty ? .empty : .loaded(recipesToShow)
    }
}
