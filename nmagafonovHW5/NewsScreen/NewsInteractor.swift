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
        static let articleErrorText: String = "Load error."
        static let articleShareErrorText: String = "Artcile to share not found"
        static let rubricId: Int = 4
        static let maxPagesToLoad: Int = 20
    }
    
    // MARK: - Variables
    private let presenter: NewsPresentationLogic
    private let worker: NewsWorker
    
    // Current page number in api.
    private var currentPageIndex: Int = 1
    // Flag to control the loading of new news.
    private var isLoadingMoreNews: Bool = false
    
    // The news array consists of a structure that will go straight into view.
    var news: [FetchedArticleData] = [] {
        didSet {
            // Switch to the main thread to update the UI.
            DispatchQueue.main.async { [weak self] in // Using weak self to prevent strong reference cycle.
                
                // Сheck that self exists.
                guard let self = self else { return }
                
                // If the news array has just filled up.
                if oldValue.isEmpty && !news.isEmpty {
                    // Transfer new news to the presenter as FreshNews
                    self.presenter
                        .presentFreshNews(
                            NewsModel.FreshNews.Response(articles: news)
                        )
                } else if !oldValue.isEmpty && news.count > oldValue.count { // If the news array has been updated with new news.
                    let newArticles = Array(news[oldValue.count..<news.count])
                    
                    // Transfer new news to the presenter as MoreNews
                    self.presenter
                        .presentMoreNews(
                            NewsModel.MoreNews.Response(articles: newArticles)
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
    
    // MARK: - Load news methods
    
    /* Оффтоп.
     Вообще можно было оставить только метод loadMoreNews и просто вызывать его, но в гайде по дз было два метода loadFreshNews и loadMoreNews, так что придумал такую странную реализацию...
     */
    
    func loadFreshNews(_ request: NewsModel.FreshNews.Request) {
        currentPageIndex = 1
        
        // Call the fetchNews method and pass the first page number.
        worker
            .fetchNews(NewsInteractorConstants.rubricId, currentPageIndex) { [weak self] fetchedNews in
                guard let self = self else { return }
                
                if let fetchedNews = fetchedNews {
                    // Transform the resulting [ArticleModel] array into [FetchedArticleData] for subsequent transmission to the presenter.
                    let newArticles = fetchedNews.map { article -> FetchedArticleData in
                        return  FetchedArticleData(
                            title: article.title ?? NewsInteractorConstants.articleErrorText,
                            announce: article.announce ?? NewsInteractorConstants.articleErrorText,
                            image: nil, // Set image to nil for now
                            imageUrl: article.img?.url,
                            articleUrl: article.articleUrl ?? NewsInteractorConstants.defaultUrl
                        )
                    }
                    
                    // Update news array with new articles.
                    self.news = newArticles
                } else {
                    // Send an error to the presenter.
                    self.presenter
                        .presentError(NewsInteractorConstants.parseErrorText)
                }
            }
    }
    
    func loadMoreNews(_ request: NewsModel.MoreNews.Request) {
        // Check the flag for loading new news and that the page limit is not exceeded.
        guard !isLoadingMoreNews, currentPageIndex < NewsInteractorConstants.maxPagesToLoad else {
            return
        }
        
        // Updating the flag and current page index.
        isLoadingMoreNews = true
        
        // Call the fetchNews method and pass the next page number.
        worker
            .fetchNews(NewsInteractorConstants.rubricId, currentPageIndex + 1) { [weak self] fetchedNews in
                guard let self = self else { return }
                
                if let fetchedNews = fetchedNews {
                    // Transform the resulting [ArticleModel] array into [FetchedArticleData] for subsequent transmission to the presenter.
                    let newArticles = fetchedNews.map { article -> FetchedArticleData in
                        return  FetchedArticleData(
                            title: article.title ?? NewsInteractorConstants.articleErrorText,
                            announce: article.announce ?? NewsInteractorConstants.articleErrorText,
                            image: nil,
                            imageUrl: article.img?.url,
                            articleUrl: article.articleUrl ?? NewsInteractorConstants.defaultUrl
                        )
                    }
                    
                    // Update news array with new articles.
                    self.currentPageIndex += 1
                    self.news += newArticles
                } else {
                    // Send an error to the presenter.
                    self.presenter
                        .presentError(NewsInteractorConstants.parseErrorText)
                }
                
                // Updating the flag.
                self.isLoadingMoreNews = false
            }
    }
    
    // MARK: - Load image method
    func loadImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        // Call the worker’s loadImage method and pass the url and closure there.
        worker.loadImage(from: url, completion: completion)
    }
    
    // MARK: - Share article method
    func shareArticle(_ request: NewsModel.Share.Request) {
        // Throw an error in the presenter if the article from request is nil.
        guard let article = request.article else {
            presenter.presentError(NewsInteractorConstants.articleShareErrorText)
            
            return
        }
        
        // Create an array to be sent to the presenter.
        let activityItems = [article.title, article.articleUrl as Any]
        
        // Calling the presenter.
        presenter
            .presentShare(
                NewsModel.Share.Response(activityItems: activityItems)
            )
    }
    
    // MARK: - Route method
    func routeTo(_ request: NewsModel.Navigation.Request) {
        presenter.routeTo(request.destination)
    }
}
