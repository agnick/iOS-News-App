//
//  NewsModels.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

enum NewsModel {
    // MARK: - FreshNews model
    enum FreshNews {
        struct Request {}
        
        struct Response {
            let articles: [FetchedArticleData]
        }
        
        struct ViewModel {
            let articles: [FetchedArticleData]
        }
    }
    
    // MARK: - MoreNews model
    enum MoreNews {
        struct Request {}
        
        struct Response {
            let articles: [FetchedArticleData]
        }
        
        struct ViewModel {
            let articles: [FetchedArticleData]
        }
    }
    
    // MARK: - Share model
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
    
    // MARK: - Navigation model
    enum Navigation {
        struct Request {
            let destination: UIViewController
        }
        
        struct Response {
        }
        
        struct ViewModel {
        }
    }
}
