//
//  ImageLoader.swift
//  Plated
//
//  Created by Trevor Beaton on 11/19/24.
//

import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?

    private let urlString: String?
    private var task: Task<Void, Never>?

    init(urlString: String?) {
        self.urlString = urlString
    }

    deinit {
        cancel()
    }

    func load() {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            print("Invalid URL String")
            return
        }

        if let cachedImage = ImageCache.shared.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                self.image = cachedImage
            }
            return
        }

        task = Task { [weak self] in
            guard let self = self else { return }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                if let uiImage = UIImage(data: data) {
                    ImageCache.shared.setObject(uiImage, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        self.image = uiImage
                    }
                }
            } catch {
                print("Failed to load image: \(error)")
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}
