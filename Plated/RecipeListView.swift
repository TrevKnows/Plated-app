//
//  RecipeListView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/18/24.
//

import SwiftUI

struct RecipeListView: View {
    let state: RecipeListState
    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    
    var body: some View {
        content
           
    }
    
    @ViewBuilder
    private var content: some View {
        switch state {
        case .loading:
            ProgressView()
                .scaleEffect(1.5)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        case .loaded(let recipes):
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(recipes, id: \.self) { recipe in
                        SmallRecipeCard(recipe: recipe)
                            .padding(.bottom)
                    }
                }
            }
            .background(Color(.systemBackground))
            .padding()
        
        case .empty:
            EmptyStateView(
                title: "No Recipes Found",
                message: "We couldn't find any recipes at the moment.\nPlease try again later.",
                image: "fork.knife.circle"
            )
        
        case .error(let error):
            EmptyStateView(
                title: "Something Went Wrong",
                message: error.localizedDescription,
                image: "exclamationmark.triangle"
            )
        }
    }
}





struct SmallRecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            ZStack(alignment: .topTrailing) {
              
                AsyncImage(url: URL(string: recipe.photoUrlSmall ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .overlay {
                            ProgressView()
                        }
                }
                .frame(height: 140)
                .clipped()

            }
            
            // Recipe Info
            VStack(alignment: .leading, spacing: 6) {
                Text(recipe.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                HStack {
                    Text(recipe.cuisine)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    if recipe.youtubeUrl != nil {
                        LinkButton(icon: "play.circle.fill", color: .red)
                    }
                    
                    if recipe.sourceUrl != nil {
                        LinkButton(icon: "link.circle.fill", color: .blue)
                    }
                }
               
                
            }
            .padding(.leading, 5)
        }
        
        .frame(height: 240)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .onTapGesture {
            handleCardTap()
        }
    }
    
    private func handleCardTap() {

        if let sourceUrl = recipe.sourceUrl, recipe.youtubeUrl == nil {
            openURL(sourceUrl)

        } else if let youtubeUrl = recipe.youtubeUrl, recipe.sourceUrl == nil {
            openURL(youtubeUrl)

        } else if recipe.sourceUrl != nil || recipe.youtubeUrl != nil {
          
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - Supporting Views
struct LinkButton: View {
    let icon: String
    let color: Color
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 24))
            .foregroundColor(color)
    }
}

// MARK: - Link Options Sheet
struct LinkOptionsSheet: View {
    let recipe: Recipe
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            if let sourceUrl = recipe.sourceUrl {
                Button {
                    openURL(sourceUrl)
                    dismiss()
                } label: {
                    Label("View Recipe", systemImage: "link")
                }
            }
            
            if let youtubeUrl = recipe.youtubeUrl {
                Button {
                    openURL(youtubeUrl)
                    dismiss()
                } label: {
                    Label("Watch Video", systemImage: "play")
                        .foregroundColor(.red)
                }
            }
        }
        .presentationDetents([.height(120)])
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}
  

#Preview {
    SmallRecipeCard(recipe: Recipe(uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f", name: "Apple & Blackberry Crumble", cuisine: "British", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg", sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4"))

}
