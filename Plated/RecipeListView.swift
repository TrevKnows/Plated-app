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
        ScrollView {
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(recipes, id: \.self) { recipe in
                    SmallRecipeCard(recipe: recipe)
                        .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    RecipeListView(recipes: [Recipe(uuid: "0c6ca6e7-e32a-4053-b824-1dbf749910d8", name: "Apam Balik", cuisine: "Malaysian", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/large.jpg", sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeUrl: "https://www.youtube.com/watch?v=6R8ffRRJcrg"),
                            
                             Recipe(uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f", name: "Apple & Blackberry Crumble", cuisine: "British", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg", sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4")
                            ])
}


struct SmallRecipeCard: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

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
        }
        .padding(.bottom, 8)
        .frame(height: 240)
        .background(Color.white)
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
