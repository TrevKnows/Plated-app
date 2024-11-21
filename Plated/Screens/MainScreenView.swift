//
//  ContentView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/17/24.
//

import SwiftUI

struct MainScreenView: View {
    @StateObject var vm = HomeViewModel(networkManager: NetworkManager())
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            MainHeaderView()
               
            SearchView(text: $vm.searchText)
            
            ScrollView {
                switch vm.state {
                case .loading:
                    LoadingView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .loaded(let recipes):
                    RecipeGridView(recipes: recipes)
                case .empty:
                    EmptyStateView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .error(let error):
                    ErrorView(error: error)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .refreshable {
                try? await vm.fetchRecipes(endpoint: .fetchAllRecipes)
            }
        }
        .task {
            try? await vm.fetchRecipes(endpoint: .fetchAllRecipes)
        }
    }
    
    func errorMessage(for error: Error) -> String {
        if error is DecodingError {
            return "Failed to load recipes due to data corruption."
        } else {
            return error.localizedDescription
        }
    }
}
#Preview {
    MainScreenView()
}
