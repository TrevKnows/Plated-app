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
        VStack(alignment: .leading) {

            Text("Plated")
                .bold()
                .font(.largeTitle)
                .foregroundStyle(.orange)
                .padding()
            
            RecipeListView(state: vm.state)
                            .refreshable {
                                try? await vm.fetchRecipes(endpoint: .fetchAllRecipes)
                            }
        }
        .navigationTitle("Plated")
        .navigationBarTitleDisplayMode(.large)
      //  .padding()
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
