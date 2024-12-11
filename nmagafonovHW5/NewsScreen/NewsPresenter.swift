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
    
    func presentOther(_ request: NewsModel.Other.Response) {
        view?.displayOther()
    }
    
    func routeTo() {
        view?.navigationController?.pushViewController(UIViewController(), animated: true)
    }
}
