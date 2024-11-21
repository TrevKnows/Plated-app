//
//  RecipeFilter.swift
//  Plated
//
//  Created by Trevor Beaton on 11/21/24.
//

import Foundation

struct RecipeFilter {
    static func filter(recipes: [Recipe], with searchText: String) -> [Recipe] {
        guard !searchText.isEmpty else { return recipes }
        return recipes.filter { recipe in
            recipe.name.localizedCaseInsensitiveContains(searchText) ||
            recipe.cuisine.localizedCaseInsensitiveContains(searchText)
        }
    }
}
