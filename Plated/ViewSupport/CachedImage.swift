//
//  CachedImage.swift
//  Plated
//
//  Created by Trevor Beaton on 11/21/24.
//

import SwiftUI

struct CachedImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    @State private var image: UIImage?
    @State private var isLoading = false
    
    init(
        url: URL?,
        scale: CGFloat = 1,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else {
                placeholder()
                    .task(id: url) {
                        await loadImage()
                    }
            }
        }
    }
    
    private func loadImage() async {
        guard !isLoading, let url = url else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        // Check cache first
        if let cachedImage = await ImageCache.shared.retrieve(forKey: url.absoluteString) {
            await MainActor.run {
                self.image = cachedImage
            }
            return
        }
        
        // Load from network if not cached
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let downloadedImage = UIImage(data: data) else { return }
            
            // Store in cache
            await ImageCache.shared.store(downloadedImage, forKey: url.absoluteString)
            
            await MainActor.run {
                self.image = downloadedImage
            }
        } catch {
            // Handle error silently, showing placeholder
            print("Error loading image: \(error)")
        }
    }
}

extension CachedImage where Content == Image {
    init(
        url: URL?,
        scale: CGFloat = 1,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.init(
            url: url,
            scale: scale,
            transaction: Transaction(),
            content: { $0 },
            placeholder: placeholder
        )
    }
}
