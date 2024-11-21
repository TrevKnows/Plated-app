//
//  ImageLoader.swift
//  Plated
//
//  Created by Trevor Beaton on 11/19/24.
//

import SwiftUI

 class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private let urlString: String?
    private var task: Task<Void, Never>?
    private let cache: ImageCache
    
    init(urlString: String?, cache: ImageCache = .shared) {
        self.urlString = urlString
        self.cache = cache
    }
    
    deinit {
        cancel()
    }
    
    func load() {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }
        
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        isLoading = true
        
        task = Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      !Task.isCancelled else {
                    return
                }
                
                if let uiImage = UIImage(data: data) {
                    cache.setObject(uiImage, forKey: urlString as NSString)
                    await MainActor.run {
                        self.image = uiImage
                        self.isLoading = false
                    }
                }
            } catch {
                print("Failed to load image: \(error)")
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
    
    func cancel() {
        task?.cancel()
        task = nil
        isLoading = false
    }
}
