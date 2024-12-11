//
//  NewsInteractor.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

final class NewsInteractor: NewsBusinessLogic, NewsDataStore {
    private let presenter: NewsPresentationLogic
    private let worker: NewsWorker
    
    var news: [ArticleModel] = [] {
        didSet {
            print("Refreshed")
        }
    }
    
    init (presenter: NewsPresentationLogic, worker: NewsWorker) {
        self.presenter = presenter
        self.worker = worker
    }
    
    func loadStart(_ request: NewsModel.Start.Request) {
        presenter.presentStart(NewsModel.Start.Response())
    }
    
    func loadOther(_ request: NewsModel.Other.Request) {
        presenter.presentOther(NewsModel.Other.Response())
    }
    
    func loadFreshNews(_request: NewsModel.Start.Request) {
        
    }
    
    func loadMoreNews(_request: NewsModel.Other.Request) {
        
    }
}
