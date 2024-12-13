//
//  NewsWorker.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

final class NewsWorker {
    // MARK: - Enums
    enum NewsWorkerConstants {
        static let newsFetchErrorText: String = "Failed to load news: "
        static let imageLoadErrorText: String = "Failed to load image: "
    }
    
    // MARK: - Variables
    private let decoder: JSONDecoder = JSONDecoder()
    
    // Declare a cache object in order to save already loaded images there and not download them again for reverse scrolling.
    private let imageCache = NSCache<AnyObject, AnyObject>()
    
    // MARK: - Fetch news
    func fetchNews(_ rubricId: Int, _ pageIndex: Int, completion: @escaping ([ArticleModel]?) -> Void) {
        // We use guard to check that the reference was returned from the method. (тк может вернуться nil)
        guard let url = getURL(rubricId, pageIndex) else { return }
        
        // Request to API to receive news.
        URLSession.shared
            .dataTask(with: url) {
                // Using weak self to prevent strong reference cycle.
                [weak self] data,
                response,
                error in
                
                // Error handling.
                if let error = error {
                    print(NewsWorkerConstants.newsFetchErrorText + "\(error.localizedDescription)")
                    return
                }
            
                // Check that the data was returned correctly.
                if let data = data,
                   // Parse data.
                   var newsPage = try? self?.decoder.decode(
                    NewsPage.self,
                    from: data
                   ) {
                    newsPage.passTheRequestId()
                    completion(newsPage.news)
                    }
            }.resume()
    }
    
    // MARK: - Image load
    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        // Checking that the url is not nil.
        guard let url = url else {
            completion(nil)
            return
        }
                
        // Check if the image is in the cache.
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            // Immediately transfer the image from the cache to the closure if it is found.
            completion(imageFromCache)
            return
        }
        
        // Request to upload an image.
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            // Error handling.
            if let error = error {
                print(NewsWorkerConstants.imageLoadErrorText + "\(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // Checking that the image is returned correctly.
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }
            
            // Save the image to cache.
            self?.imageCache.setObject(image, forKey: url.absoluteString as AnyObject)
            
            completion(image)
        }.resume()
    }
    
    // MARK: - URL prepare
    private func getURL(_ rubric: Int, _ pageIndex: Int) -> URL? {
        URL(
            string: "https://news.myseldon.com/api/Section?rubricId=\(rubric)&pageSize=8&pageIndex=\(pageIndex)"
        )
    }
}

