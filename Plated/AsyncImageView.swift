//
//  AsyncImageView.swift
//  Plated
//
//  Created by Trevor Beaton on 11/20/24.
//

import SwiftUI

struct AsyncImageView: View {
    @StateObject private var loader: ImageLoader
    private let placeholder: Image

    init(urlString: String?, placeholder: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: ImageLoader(urlString: urlString))
        self.placeholder = placeholder
    }

    var body: some View {
        imageView
            .onAppear {
                loader.load()
            }
            .onDisappear {
                loader.cancel()
            }
    }

    private var imageView: some View {
        Group {
            if let uiImage = loader.image {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                placeholder
                    .resizable()
            }
        }
    }
}

