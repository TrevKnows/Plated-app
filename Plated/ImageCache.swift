//
//  ImageCache.swift
//  Plated
//
//  Created by Trevor Beaton on 11/19/24.
//

import Foundation
import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()

    private init() {
        cache.totalCostLimit = 1024 * 1024 * 50 
    }
    

    func object(forKey key: NSString) -> UIImage? {
        cache.object(forKey: key)
    }

    func setObject(_ obj: UIImage, forKey key: NSString) {
        cache.setObject(obj, forKey: key)
    }
}
