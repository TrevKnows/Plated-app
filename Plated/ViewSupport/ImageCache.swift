//
//  ImageCache.swift
//  Plated
//
//  Created by Trevor Beaton on 11/19/24.
//

import Foundation
import UIKit
import SwiftUI

actor ImageCache {
    static let shared = ImageCache()
    
    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    
    private let maxMemoryCacheSize = 1024 * 1024 * 50
    private let maxDiskCacheSize = 1024 * 1024 * 100
    
    private var diskCacheURL: URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("ImageCache")
    }
    
    private init() {
        memoryCache.totalCostLimit = maxMemoryCacheSize

        Task {
            await self.setupDiskCache()
        }
        
        // Handle memory warnings asynchronously
        Task {
            for await _ in await NotificationCenter.default.notifications(named: UIApplication.didReceiveMemoryWarningNotification) {
                await self.clearMemoryCache()
            }
        }
    }
    
    private func setupDiskCache() async {
        do {
            try fileManager.createDirectory(at: diskCacheURL, withIntermediateDirectories: true)
        } catch {
            print("Failed to create disk cache directory: \(error)")
        }
    }
    
    private func clearMemoryCache() async {
        memoryCache.removeAllObjects()
    }
    
    func clearDiskCache() async {
        do {
            try fileManager.removeItem(at: diskCacheURL)
            await setupDiskCache()
        } catch {
            // Handle the error appropriately
            print("Failed to clear disk cache: \(error)")
        }
    }
    
    private func diskCacheFileURL(for key: String) -> URL {
        let fileName = key.hashValue.description
        return diskCacheURL.appendingPathComponent(fileName)
    }
    
    func store(_ image: UIImage, forKey key: String) async {
        let cost = Int(image.size.width * image.size.height * 4)
        memoryCache.setObject(image, forKey: key as NSString, cost: cost)
        
        let fileURL = diskCacheFileURL(for: key)
        if let data = image.jpegData(compressionQuality: 0.8) {
            do {
                try data.write(to: fileURL)
            } catch {
                // Handle the error appropriately
                print("Failed to write image to disk: \(error)")
            }
        }
    }
    
    func retrieve(forKey key: String) async -> UIImage? {
        if let image = memoryCache.object(forKey: key as NSString) {
            return image
        }
        
        let fileURL = diskCacheFileURL(for: key)
        do {
            let data = try Data(contentsOf: fileURL)
            if let image = UIImage(data: data) {
                memoryCache.setObject(image, forKey: key as NSString)
                return image
            }
        } catch {
            print("Failed to read image from disk: \(error)")
        }
        
        return nil
    }
}
