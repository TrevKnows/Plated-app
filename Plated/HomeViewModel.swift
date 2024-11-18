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
    
    func fetchRecipes() async throws {
        do {
            let recipes = try await networkManager.fetchData(for: RecipeAPI.fetchAllRecipes, responseType: [Recipe].self)

            DispatchQueue.main.async {
                self.recipesLoaded = recipes
            }

        } catch let error as APIError {
            DispatchQueue.main.async {
                self.error = error
            }
            
            print("API Error: \(error.localizedDescription)")
            throw error
        } catch {
            // Handle unknown errors
            let genericError = APIError.decodingError
            DispatchQueue.main.async {
                self.error = genericError
            }
            
            print("Unknown Error: \(error.localizedDescription)")
            throw genericError
        }
    }
    
}
