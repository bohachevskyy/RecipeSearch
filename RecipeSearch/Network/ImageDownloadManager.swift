//
//  ImageDownloadManager.swift
//  RecipeSearch
//
//  Created by Mark Vasiv on 30/05/2019.
//  Copyright © 2019 Mark Vasiv. All rights reserved.
//

import Foundation

class ImageDownloadManager {
    static private var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    static func downloadImage(url urlString: String, completion: @escaping (Result<UIImage, Error>) -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(.success(cachedImage))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let result: Result<UIImage, Error>
            
            if let error = error {
                result = .failure(error)
            } else if let data = data,
                let image = UIImage(data: data) {
                result = .success(image)
            } else {
                result = .failure(NetworkError.invalidURL)
            }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.imageCache.setObject(image, forKey: urlString as NSString)
                case .failure(_):
                    break
                }
                
                completion(result)
            }
        }
        
        task.resume()
    }
}
