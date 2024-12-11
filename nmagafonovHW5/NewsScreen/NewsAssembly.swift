//
//  NewsAssembly.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

enum NewsAssembly {
    static func build() -> UIViewController {
        let presenter = NewsPresenter()
        let worker = NewsWorker()
        let interactor = NewsInteractor(presenter: presenter, worker: worker)
        let view = NewsViewController(interactor: interactor)
        presenter.view = view
        
        return view
    }
}
