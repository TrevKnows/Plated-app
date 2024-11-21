//
//  RecipeListView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/18/24.
//

import SwiftUI

struct RecipeCardCellView: View {
    let recipe: Recipe
    @Environment(\.horizontalSizeClass) private var sizeClass
    
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var imageHeight: CGFloat {
        isIPad ? 200 : 140
    }
    
    private var cardHeight: CGFloat {
        isIPad ? 320 : 260
    }
    
    private var imageURL: String? {
        isIPad ? recipe.photoUrlLarge : recipe.photoUrlSmall
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CachedImage(url: URL(string: imageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: imageHeight)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .overlay {
                        ProgressView()
                    }
                    .frame(height: imageHeight)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(recipe.name)
                    .font(isIPad ? .title3 : .subheadline)
                    .fontWeight(.medium)
                    .lineLimit(1)
                
                HStack {
                    Text(recipe.cuisine)
                        .font(isIPad ? .caption : .caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Capsule())
                    
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    if recipe.youtubeUrl != nil {
                        LinkButtonView(icon: "play.circle.fill", color: .red)
                            .imageScale(isIPad ? .large : .medium)
                            .onTapGesture {
                                handleYouTubeButtonTap()
                            }
                        
                    }
                    
                    if recipe.sourceUrl != nil {
                        LinkButtonView(icon: "link.circle.fill", color: .blue)
                            .imageScale(isIPad ? .large : .medium)
                            .onTapGesture {
                                handleSourceButtonTap()
                            }
                    }
                }
                .padding(.bottom)
            }
            .padding(.leading, 5)
        }
        .frame(height: cardHeight)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func handleYouTubeButtonTap() {
        guard let youtubeUrl = recipe.youtubeUrl else { return }
        openURL(youtubeUrl)
    }
    
    private func handleSourceButtonTap() {
        guard let sourceUrl = recipe.sourceUrl else { return }
        openURL(sourceUrl)
    }
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
}



  

#Preview {
    RecipeCardCellView(recipe: Recipe(uuid: "599344f4-3c5c-4cca-b914-2210e3b3312f", name: "Apple & Blackberry Crumble", cuisine: "British", photoUrlSmall: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/small.jpg", photoUrlLarge: "https://d3jbb8n5wk0qxi.cloudfront.net/photos/535dfe4e-5d61-4db6-ba8f-7a27b1214f5d/large.jpg", sourceUrl: "https://www.nyonyacooking.com/recipes/apam-balik~SJ5WuvsDf9WQ", youtubeUrl: "https://www.youtube.com/watch?v=4vhcOwVBDO4"))

}
