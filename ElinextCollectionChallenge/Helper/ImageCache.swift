//
//  ImageCache.swift
//  ElinextCollectionChallenge
//
//  Created by Kazu on 28/9/24.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(_ image: UIImage, forKey key: NSString) {
        cache.setObject(image, forKey: key)
    }
    
    func image(forKey key: NSString) -> UIImage? {
        return cache.object(forKey: key)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
