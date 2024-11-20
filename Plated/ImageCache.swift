//
//  ImageCache.swift
//  Plated
//
//  Created by Trevor Beaton on 11/19/24.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
}
