//
//  NewsPresenter.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

final class NewsPresenter: NewsPresentationLogic {
    weak var view: NewsViewController?
    
    func presentFreshNews(_ request: NewsModel.FreshNews.Response) {
        DispatchQueue.main.async {
            self.view?.activityIndicator.stopAnimating()
            self.view?.newsTableView.reloadData()
        }
    }
    
    func presentMoreNews(_ request: NewsModel.MoreNews.Response) {
        DispatchQueue.main.async {
            let startIndex = self.view?.newsTableView.numberOfRows(inSection: 0) ?? 0
            let endIndex = startIndex + request.articles.count
            let indexPath = (startIndex..<endIndex).map {
                IndexPath(row: $0, section: 0)
            }
            
            self.view?.newsTableView.performBatchUpdates({
                self.view?.newsTableView.insertRows(at: indexPath, with: .automatic)
            }, completion: { success in
                if !success {
                    self.presentError("Error inserting new articles")
                }
            })
        }
    }

    
    func presentError(_ request: String) {
        DispatchQueue.main.async {
            guard let view = self.view else { return }
            
            let alertController = UIAlertController(title: "Error", message: request, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            view.present(alertController, animated: true , completion: nil)
        }
    }
    
    func presentShare(_ response: NewsModel.Share.Response) {
        DispatchQueue.main.async {
            guard let view = self.view else { return }
            
            let activityViewController = UIActivityViewController(activityItems: response.activityItems, applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceView = view.view
            
            view.present(activityViewController, animated: true , completion: nil)
        }
    }
    
    
    func routeTo(_ viewController: UIViewController) {
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
}
