//
//  NewsInteractor.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

final class NewsInteractor: NewsBusinessLogic, NewsDataStore {
    //MARK: - Enums
    enum NewsInteractorConstants {
        static let defaultUrl: URL = URL(
            string: "https://news.myseldon.com/ru/"
        )!
        static let parseErrorText: String = "Failed to load news."
        static let articleTextError: String = "Load error."
        static let rubricId: Int = 4
        static let maxPagesToLoad: Int = 20
    }
    
    // MARK: - Variables
    private let presenter: NewsPresentationLogic
    private let worker: NewsWorker
    
    private var currentPageIndex: Int = 1
    private var isLoadingMoreNews: Bool = false
    
    var news: [FetchedArticleData] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                if oldValue.isEmpty && !news.isEmpty {
                    self.presenter.presentFreshNews(NewsModel.FreshNews.Response(articles: news))
                } else if !oldValue.isEmpty && news.count > oldValue.count {
                    let newArticles = Array(news[oldValue.count..<news.count])
                    self.presenter.presentMoreNews(NewsModel.MoreNews.Response(articles: newArticles))
                }
            }
        }
    }
    
    
    // MARK: - Lifecycle
    init (presenter: NewsPresentationLogic, worker: NewsWorker) {
        self.presenter = presenter
        self.worker = worker
    }
    
    // MARK: - Load news methods
    func loadFreshNews(_ request: NewsModel.FreshNews.Request) {
        currentPageIndex = 1
        
        worker.fetchNews(NewsInteractorConstants.rubricId, currentPageIndex) { [weak self] fetchedNews in
                guard let self = self else { return }
                
                if let fetchedNews = fetchedNews {
                    
                    let newArticles = fetchedNews.map { article -> FetchedArticleData in
                        return  FetchedArticleData(
                            title: article.title ?? NewsInteractorConstants.articleTextError,
                            announce: article.announce ?? NewsInteractorConstants.articleTextError,
                            image: nil,
                            imageUrl: article.img?.url,
                            articleUrl: article.articleUrl ?? NewsInteractorConstants.defaultUrl
                        )
                    }
                    
                    self.news = newArticles
                } else {
                    self.presenter.presentError(NewsInteractorConstants.parseErrorText)
                }
        }
    }
    
    func loadMoreNews(_ request: NewsModel.MoreNews.Request) {
        guard !isLoadingMoreNews, currentPageIndex < NewsInteractorConstants.maxPagesToLoad else {
            return
        }
        
        isLoadingMoreNews = true
        let nextPageIndex = currentPageIndex + 1
        
        worker.fetchNews(NewsInteractorConstants.rubricId, currentPageIndex) { [weak self] fetchedNews in
                guard let self = self else { return }
                
                if let fetchedNews = fetchedNews {
                    self.currentPageIndex = nextPageIndex
                    
                    let newArticles = fetchedNews.map { article -> FetchedArticleData in
                        return  FetchedArticleData(
                            title: article.title ?? NewsInteractorConstants.articleTextError,
                            announce: article.announce ?? NewsInteractorConstants.articleTextError,
                            image: nil,
                            imageUrl: article.img?.url,
                            articleUrl: article.articleUrl ?? NewsInteractorConstants.defaultUrl
                        )
                    }
                    
                    self.news += newArticles
                } else {
                    self.presenter.presentError(NewsInteractorConstants.parseErrorText)
                }
                
                self.isLoadingMoreNews = false
        }
    }
    
    func loadImage(for index: Int, completion: @escaping (UIImage?) -> Void) {
        guard index < news.count, let imageURL = news[index].imageUrl else {
            completion(nil)
            return
        }
        
        worker.loadImage(from: imageURL) { [weak self] image in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let image = image {
                    self.news[index].image = image
                }
               
                completion(image)
            }
        }
    }
    
    func shareArticle(_ request: NewsModel.Share.Request) {
        guard let article = request.article else {
            presenter.presentError("Artcile to share not found")
            return
        }
        
        let activityItems = [article.title, article.articleUrl as Any]
        
        presenter.presentShare(NewsModel.Share.Response(activityItems: activityItems))
    }
    
    func routeTo(_ request: NewsModel.Navigation.Request) {
        presenter.routeTo(request.destination)
    }
}
