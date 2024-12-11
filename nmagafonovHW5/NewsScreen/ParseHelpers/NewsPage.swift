//
//  NewsPage.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

struct NewPage: Decodable {
    var news: [ArticleModel]?
    var requestId: String?
    
    mutating func passTheRequestId() {
        for i in 0..<(news?.count ?? 0) {
            news?[i].requestId = requestId
        }
    }
}
