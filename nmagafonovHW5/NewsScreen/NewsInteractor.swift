//
//  NewsInteractor.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

final class NewsInteractor: NewsBusinessLogic, NewsDataStore {
    // MARK: - Variables
    private let presenter: NewsPresentationLogic
    private let worker: NewsWorker
    
    var news: [ArticleModel] = [] {
        didSet {
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                
                self.getDataFromNews(self.news) {
                    fetchedArticles in self.presenter
                        .presentFreshNews(
                            NewsModel.FreshNews
                                .Response(articles: fetchedArticles)
                        )
                }
            }
        }
    }
    
    // MARK: - Lifecycle
    init (presenter: NewsPresentationLogic, worker: NewsWorker) {
        self.presenter = presenter
        self.worker = worker
    }
    
    // MARK: - Start load
    func loadStart(_ request: NewsModel.Start.Request) {
        presenter.presentStart(NewsModel.Start.Response())
    }
    
    func loadOther(_ request: NewsModel.Other.Request) {
        
    }
    
    // MARK: - Load news methods
    func loadFreshNews(_ request: NewsModel.FreshNews.Request) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            self.worker.fetchNews{[weak self] fetchedNews in
                guard let self = self else { return }
                if let fetchedNews = fetchedNews {
                    DispatchQueue.main.async {
                        self.news = fetchedNews
                    }
                } else {
                    DispatchQueue.main.async {
                        self.presenter
                            .presentError("Не удалось загрузить новости.")
                    }
                }
            }
        }
    }
    
    func loadMoreNews(_ request: NewsModel.MoreNews.Request) {
        
    }
    
    // MARK: - Private methods
    private func getDataFromNews(
        _ news: [ArticleModel],
        completion: @escaping ([FetchedArticleData]) -> Void
    ) {
        var fetchedArticles: [FetchedArticleData] = []
        let group = DispatchGroup()
        
        for item in news {
            group.enter()
            
            worker.loadImage(from: item.img?.url) {
                image in
                let articleData = FetchedArticleData(
                    title: item.title ?? "Ошибка заголовка",
                    announce: item.announce ?? "Ошибка описания",
                    image: image ?? UIImage()
                )
                fetchedArticles.append(articleData)
                group.leave()
            }
            
        }
        
        group.notify(queue: .main) {
            completion(fetchedArticles)
        }
    }
}
