//
//  RecipeListView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/18/24.
//

import SwiftUI

struct RecipeListView: View {
    var recipes: [Recipe]
  
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 5) {
            
            ForEach(recipes, id: \.self) { recipe in
                
                RecipeSaveCell(recipe: recipe)
                    .padding(.horizontal)
            }
            
        }
    }
}

#Preview {
    RecipeListView(recipes: [Recipe(uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", name: "Apam Balik", cuisine: "Malaysian", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg"),
                            
                             Recipe(uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f", name: "Apple & Blackberry Crumble", cuisine: "British", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg", sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4")
                            ])
}
