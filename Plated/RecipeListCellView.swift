//
//  RecipeListCellView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/18/24.
//

import SwiftUI

struct RecipeSaveCell: View {
   
    let recipe: Recipe
    
    var body: some View {
        VStack(spacing: 0) {

            AsyncImage(url: URL(string: recipe.photoUrlSmall ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay {
                        ProgressView()
                    }
            }
            .frame(height: 200)
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {

                Text(recipe.name)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(recipe.sourceUrl ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                

            }
            .padding(12)
        }
        
        .background(Color.white)
        .cornerRadius(16)
       
    }
}


