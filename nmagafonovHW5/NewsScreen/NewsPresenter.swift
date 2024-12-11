//
//  NewsPresenter.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

final class NewsPresenter: NewsPresentationLogic {
    weak var view: NewsViewController?
    
    func presentStart(_ request: NewsModel.Start.Response) {
        view?.displayStart()
    }
    
    func presentFreshNews(_ request: NewsModel.FreshNews.Response) {
    
        view?.displayFreshNews(NewsModel.FreshNews.ViewModel(articles: request.articles))
    }
    
    func presentMoreNews(_ request: NewsModel.MoreNews.Response) {
        
    }
    
    func presentError(_ request: String) {
        print(request)
    }
    
    
    func routeTo() {
        view?.navigationController?.pushViewController(UIViewController(), animated: true)
    }
}
