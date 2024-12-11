//
//  NewsWorker.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

final class NewsWorker {
    // MARK: - Variables
    private let decoder: JSONDecoder = JSONDecoder()
    
    // MARK: - Fetch news
    func fetchNews(completion: @escaping ([ArticleModel]?) -> Void) {
        guard let url = getURL(4, 1) else { return }
        
        URLSession.shared
            .dataTask(with: url) {
                [weak self] data,
                response,
                error in
                if let error = error {
                    print(error)
                    return
                }
            
                if let data = data,
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
        guard let url = url else {
            completion(nil)
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    // MARK: - URL prepare
    private func getURL(_ rubric: Int, _ pageIndex: Int) -> URL? {
        URL(
            string: "https://news.myseldon.com/api/Section?rubricId=\(rubric)&pageSize=8&pageIndex=\(pageIndex)"
        )
    }
}

