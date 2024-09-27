//
//  CellViewModel.swift
//  ElinextCollectionChallenge
//
//  Created by Kazu on 27/9/24.
//

import Foundation
import UIKit

class CellViewModel {
    let cacheKey = NSString(string: UUID().uuidString)
        
    var imageTask: Task<Void, Never>?

    init() { }
    
    func downloadImage(completion: @escaping (UIImage) -> Void) {
        if let cachedImage = ImageCache.shared.image(forKey: cacheKey) {
            completion(cachedImage)
            return
        }
        
        // if there's a task before, cancel it
        imageTask?.cancel()
        
        imageTask = Task {
            let url = Constant.imageUrl
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    completion(UIImage(systemName: "photo") ?? UIImage())
                    return
                }
                
                if let image = UIImage(data: data) {
                    ImageCache.shared.setImage(image, forKey: cacheKey)
                    completion(image)
                } else {
                    completion(UIImage(systemName: "photo") ?? UIImage())
                }
                
            } catch {
                if let urlError = error as? URLError {
                    switch urlError.code {
                    case .notConnectedToInternet:
                        print("No internet connection.")
                    default:
                        print("Other URL error: \(urlError.localizedDescription)")
                    }
                } else {
                    print("Image fetch failed: \(error)")
                }
                completion(UIImage(systemName: "photo") ?? UIImage())
            }
        }
        
    }
}
