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
        ZStack {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
            } else {
                placeholder
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray.opacity(0.3))
                
                if loader.isLoading {
                    ProgressView()
                }
            }
        }
        .onAppear {
            loader.load()
        }
        .onDisappear {
            loader.cancel()
        }
    }
}

