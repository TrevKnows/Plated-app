//
//  RecipeListCellView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/18/24.
//

import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe

    var body: some View {
        HStack {
            if let urlString = recipe.photoUrlSmall {
                AsyncImageView(urlString: urlString)
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }
}



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
            
            Divider()
            
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
            .padding(8)
        }
        
        .background(Color.white)
        .cornerRadius(16)
       
    }
}


