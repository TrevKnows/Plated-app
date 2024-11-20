//
//  ContentView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/17/24.
//

import SwiftUI

struct ContentView: View {
       @StateObject var vm = HomeViewModel(networkManager: NetworkManager())
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            RecipeListView(recipes: vm.recipesLoaded)
        }
        .padding()
        .onAppear {
            Task {
                try await vm.fetchRecipes(endpoint: RecipeAPI.fetchAllRecipes)
            }
        }
    }
}

#Preview {
    ContentView()
}
