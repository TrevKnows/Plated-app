//
//  RecipeListCellView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/18/24.
//

import SwiftUI

struct RecipeSaveCell: View {
    let imageUrl: String
    let title: String
    let websiteUrl: String
    let onSaveTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Image
            AsyncImage(url: URL(string: imageUrl)) { image in
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
            
            // Text and Button Container
            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(title)
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Website URL
                Text(websiteUrl)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                // Save Button
                Button(action: onSaveTap) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Save")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(red: 203/255, green: 109/255, blue: 81/255))
                    .cornerRadius(24)
                }
                .padding(.top, 4)
            }
            .padding(12)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}


