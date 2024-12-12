//
//  NewsModels.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

enum NewsModel {
    enum FreshNews {
        struct Request {}
        
        struct Response {
            let articles: [FetchedArticleData]
        }
        
        struct ViewModel {
            let articles: [FetchedArticleData]
        }
    }
    
    enum MoreNews {
        struct Request {}
        
        struct Response {
            let articles: [FetchedArticleData]
        }
        
        struct ViewModel {
            let articles: [FetchedArticleData]
        }
    }
    
    enum Share {
        struct Request {
            let article: FetchedArticleData?
        }
        
        struct Response {
            let activityItems: [Any]
        }
        
        struct ViewModel {
        }
    }
    
    enum Navigation {
        struct Request {
            let destination: UIViewController
        }
    }
}
