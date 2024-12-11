//
//  NewsModels.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

enum NewsModel {
    enum Start {
        struct Request {}
        
        struct Response {}
        
        struct ViewModel {}
    }
    
    enum Other {
        struct Request {}
        
        struct Response {}
        
        struct ViewModel {}
    }
    
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
        
        struct Response {}
        
        struct ViewModel {}
    }
}
