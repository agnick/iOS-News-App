//
//  CustomImageView.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 13.12.2024.
//

import UIKit

/*
 Решение проблемы с гонкой запросов при загрузке изображений в ячейки. Возможно можно было сделать в интеракторе и воркере, но я не придумал решения :(.
 */

final class CustomImageView: UIImageView {
    // MARK: - Variables
    // Variable that stores the download task.
    var task: URLSessionDataTask!
    // Activity spinner initialization.
    let spinner = UIActivityIndicatorView(style: .large)
    
    // MARK: - Set image public method
    func setImage(from url: URL, interactor: (NewsBusinessLogic & NewsDataStore)) {
        // Set the image to nil.
        image = nil
        // Call method to configure and activate activity spinner.
        addSpinner()
        
        // Initially, task will contain nil and the first download request will not be stopped, all subsequent requests will be stopped. This prevents request races and allows you to install correct images without lags.
        if let task = task {
            task.cancel()
        }
        
        // Calling the interactor to load the image.
        interactor.loadImage(for: url) { [weak self] image in
            // Switch to the main thread to update the UI.
            DispatchQueue.main.async {
                self?.image = image
                
                // Remove activity spinner if the resulting image is not nil.
                if image != nil {
                    self?.removeSpinner()
                }
            }
        }
    }
    
    // MARK: - Private spinner methods
    private func addSpinner() {
        addSubview(spinner)
        
        // Spinner constraints.
        spinner.pinHorizontal(to: self)
        spinner.pinTop(to: self, 50)
        
        spinner.startAnimating()
    }
    
    private func removeSpinner() {
        spinner.removeFromSuperview()
    }
}
