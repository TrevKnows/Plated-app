//
//  RecipeListView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/18/24.
//

import SwiftUI

struct RecipeListView: View {
    var recipes: [Recipe]
  
    var body: some View {
        LazyVGrid(columns: [.init(), .init()]) {
            
        }
    }
}

#Preview {
    RecipeListView(recipes: [])
}
