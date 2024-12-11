//
//  NewsViewController.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

final class NewsViewController: UIViewController {
    // MARK: - Enums
    enum NewsConstants {
        // View settings.
        static let viewBackgroundColor: UIColor = UIColor(hex: "#282828") ?? .clear
        
        // NewsTableView settings.
        static let newsTableViewTop: CGFloat = 10
        static let newsTableViewBottom: CGFloat = 10
        static let newsTableViewLeading: CGFloat = 10
        static let newsTableViewTrailing: CGFloat = 10
        static let newsTableRowsHeight: CGFloat = 350
    }
    
    // MARK: - Variables
    private var interactor: (NewsBusinessLogic & NewsDataStore)?
    private var news: [FetchedArticleData] = []
    
    // UI components.
    private let newsTableView: UITableView = UITableView(frame: .zero)
    
    // MARK: - Lifecycle
    init(interactor: (NewsBusinessLogic & NewsDataStore)) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(parameters:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        interactor?.loadFreshNews(NewsModel.FreshNews.Request())
    }
    
    // MARK: - Public Methods
    func displayStart() {}
    
    func displayOther() {}
    
    func displayFreshNews(_ viewModel: NewsModel.FreshNews.ViewModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.news = viewModel.articles
            self.newsTableView.reloadData()
        }
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        view.backgroundColor = NewsConstants.viewBackgroundColor
        
        configureNewsTableView()
    }
    
    private func configureNewsTableView() {
        view.addSubview(newsTableView)
        
        newsTableView.backgroundColor = .clear
        
        // Set the data source and delegate for the tableView view.
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        // Register the cell class for reuse.
        newsTableView
            .register(NewsCell.self, forCellReuseIdentifier: NewsCell.reuseId)
        
        newsTableView.isScrollEnabled = true
        newsTableView.alwaysBounceVertical = true
        
        // Set constraints to position the table view.
        newsTableView
            .pinTop(
                to: view.safeAreaLayoutGuide.topAnchor,
                NewsConstants.newsTableViewTop
            )
        newsTableView
            .pinBottom(
                to: view.safeAreaLayoutGuide.bottomAnchor,
                NewsConstants.newsTableViewBottom
            )
        newsTableView.pinLeft(to: view, NewsConstants.newsTableViewLeading)
        newsTableView.pinRight(to: view, NewsConstants.newsTableViewTrailing)
    }
        
}

// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsCell.reuseId,
            for: indexPath
        ) as! NewsCell
        
        let idx = indexPath.row
        if (news.indices.contains(idx)) {
            cell.configure(news[idx].title, news[idx].announce, news[idx].image)
        }
                
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewsViewController : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return NewsConstants.newsTableRowsHeight
    }
}
