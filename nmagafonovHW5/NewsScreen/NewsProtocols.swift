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
    
    func loadFreshNews(_request: NewsModel.Start.Request)
    func loadMoreNews(_request: NewsModel.Other.Request)
}

protocol NewsPresentationLogic {
    func presentStart(_ response: NewsModel.Start.Response)
    func presentOther(_ response: NewsModel.Other.Response)
    
    func routeTo()
}
