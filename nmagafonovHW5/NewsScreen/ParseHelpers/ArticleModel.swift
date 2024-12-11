//
//  ArticleModel.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import Foundation

struct ArticleModel : Decodable {
    var newsId: Int?
    var title: String?
    var announce: String?
    var img: ImageContainer?
    var requestId: String?
    var articleUrl: URL? {
        let newsId = newsId ?? 0
        let requestId = requestId ?? ""
        
        return URL(string: "https://news.myseldon.com/ru/news/index/\(newsId)?requestId=\(requestId)")
    }
}
