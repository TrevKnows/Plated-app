//
//  RecipeGridView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/21/24.
//

import SwiftUI

struct RecipeGridView: View {
    let recipes: [Recipe]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(recipes, id: \.self) { recipe in
                    RecipeCardCellView(recipe: recipe)
                        .padding(.bottom)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    RecipeGridView(recipes: [])
}
