//
//  NewsProtocols.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

protocol NewsBusinessLogic {
    func loadStart(_ request: NewsModel.Start.Request)
    func loadOther(_ request: NewsModel.Other.Request)
}

protocol NewsDataStore {
    var news: [ArticleModel] { get set }
    
    func loadFreshNews(_ request: NewsModel.FreshNews.Request)
    func loadMoreNews(_ request: NewsModel.MoreNews.Request)
}

protocol NewsPresentationLogic {
    func presentStart(_ response: NewsModel.Start.Response)
    func presentFreshNews(_ response: NewsModel.FreshNews.Response)
    func presentMoreNews(_ response: NewsModel.MoreNews.Response)
    func presentError(_ response: String)
    
    func routeTo()
}
