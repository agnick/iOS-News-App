//
//  NewsProtocols.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

// MARK: - NewsBusinessLogic protocols
protocol NewsBusinessLogic {
    func loadFreshNews(_ request: NewsModel.FreshNews.Request)
    func loadMoreNews(_ request: NewsModel.MoreNews.Request)
    func shareArticle(_ request: NewsModel.Share.Request)
    func routeTo(_ request: NewsModel.Navigation.Request)
    
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void)
}

// MARK: - NewsDataStore protocols
protocol NewsDataStore {
    var news: [FetchedArticleData] { get set }
}

// MARK: - NewsPresentationLogic protocols
protocol NewsPresentationLogic {
    func presentFreshNews(_ response: NewsModel.FreshNews.Response)
    func presentMoreNews(_ response: NewsModel.MoreNews.Response)
    func presentError(_ response: String)
    func presentShare(_ response: NewsModel.Share.Response)
    
    func routeTo(_ viewController: UIViewController)
}
