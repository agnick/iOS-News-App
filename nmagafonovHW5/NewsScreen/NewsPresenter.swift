//
//  NewsPresenter.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

final class NewsPresenter: NewsPresentationLogic {
    // MARK: - Enums
    enum NewsPresenterConstants {
        static let insertToTableErrorText: String = "Error inserting new articles"
        static let alertControllerTitle: String = "Error"
        static let alertControllerActionTitle: String = "OK"
    }
    
    // MARK: - Variables
    weak var view: NewsViewController?
    
    // MARK: - Present public methods
    func presentFreshNews(_ request: NewsModel.FreshNews.Response) {
        // Switch to the main thread to update the UI.
        DispatchQueue.main.async {
            // Stop the activity indicator.
            self.view?.activityIndicator.stopAnimating()
            // Update the data in the table, here this can be done using reloadData, since there is still more data.
            self.view?.newsTableView.reloadData()
        }
    }
    
    func presentMoreNews(_ request: NewsModel.MoreNews.Response) {
        // Switch to the main thread to update the UI.
        DispatchQueue.main.async {
            // Get the current index of the last row in the table.
            let startIndex = self.view?.newsTableView.numberOfRows(inSection: 0) ?? 0
            // Get the index where new lines end.
            let endIndex = startIndex + request.articles.count
            // An array of IndexPath objects is created for each row that needs to be added. It is used to update the table.
            let indexPath = (startIndex..<endIndex).map {
                IndexPath(row: $0, section: 0)
            }
            
            // Update the table by inserting new rows in order to avoid the table flickering effect when adding new data.
            self.view?.newsTableView.performBatchUpdates({
                self.view?.newsTableView.insertRows(at: indexPath, with: .automatic)
            }, completion: { success in
                // Sending an insert error to the presentError method.
                if !success {
                    self.presentError(NewsPresenterConstants.insertToTableErrorText)
                }
            })
        }
    }

    func presentError(_ request: String) {
        // Switch to the main thread to update the UI.
        DispatchQueue.main.async {
            // Check that view is correct and not equal to nil.
            guard let view = self.view else { return }
            
            // Initialize UIAlertController to notify the user about an error.
            let alertController = UIAlertController(title: NewsPresenterConstants.alertControllerTitle, message: request, preferredStyle: .alert)
            
            // Adding a action to exit the alert.
            alertController.addAction(UIAlertAction(title: NewsPresenterConstants.alertControllerActionTitle, style: .default, handler: nil))
            
            // Show alert in view.
            view.present(alertController, animated: true , completion: nil)
        }
    }
    
    func presentShare(_ response: NewsModel.Share.Response) {
        // Switch to the main thread to update the UI.
        DispatchQueue.main.async {
            // Check that view is correct and not equal to nil.
            guard let view = self.view else { return }
            
            // Setup UIActivityViewController. Pass into it the structure for sharing obtained from the response.
            let activityViewController = UIActivityViewController(activityItems: response.activityItems, applicationActivities: nil)
            
            activityViewController.popoverPresentationController?.sourceView = view.view
            
            // Show activityViewController in view.
            view.present(activityViewController, animated: true , completion: nil)
        }
    }
    
    
    func routeTo(_ viewController: UIViewController) {
        // Adding the new passed screen to the stack.
        view?.navigationController?.pushViewController(viewController, animated: true)
    }
}
