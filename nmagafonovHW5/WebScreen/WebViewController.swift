//
//  WebViewController.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 12.12.2024.
//

import WebKit
import UIKit

final class WebViewController : UIViewController {
    // MARK: - Variables
    private var url: URL
    
    // UI components.
    private let webView: WKWebView = WKWebView()
    
    // MARK: - Lifecycle
    init(_ webUrl: URL) {
        url = webUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(parameters:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: url))
        
        configureWebView()
    }
    
    // MARK: - Private Methods
    private func configureWebView() {
        view.addSubview(webView)
        
        webView.pinHorizontal(to: view)
        webView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        webView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
}
