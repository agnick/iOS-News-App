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
        static let viewBackgroundColor: UIColor = UIColor(
            hex: "#282828"
        ) ?? .clear
        
        // NewsTableView settings.
        static let newsTableViewTop: CGFloat = 10
        static let newsTableViewBottom: CGFloat = 10
        static let newsTableViewLeading: CGFloat = 10
        static let newsTableViewTrailing: CGFloat = 10
        static let newsTableRowsHeight: CGFloat = 350
        static let newsTableScrollDist: CGFloat = 200
    }
    
    // MARK: - Variables
    var interactor: (NewsBusinessLogic & NewsDataStore)?
    
    // UI components.
    let newsTableView: UITableView = UITableView(frame: .zero)
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
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
        
        // UI setup.
        configureUI()
        
        // Launch the activity indicator until the news has loaded.
        activityIndicator.startAnimating()
        
        // Call the loadFreshNews method on the interactor to load fresh news from the first page of the api.
        interactor?.loadFreshNews(NewsModel.FreshNews.Request())
    }
        
    // MARK: - Private Methods
    private func configureUI() {
        view.backgroundColor = NewsConstants.viewBackgroundColor
        
        // Table setup.
        configureNewsTableView()
        // Activity indicator setup.
        configureActivityIndicator()
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
    
    private func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        
        // Set indicator settings.
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        
        // Set constraints to position the indicator.
        activityIndicator.pinCenter(to: view)
    }
        
}

// MARK: - UITableViewDataSource
extension NewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.news.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsCell.reuseId,
            for: indexPath
        ) as! NewsCell
        
        // Get the current article and call the configurator in this cell.
        if let article = interactor?.news[indexPath.row] {
            cell.configure(article, interactor!)
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
        // We call the interactor and get a link to the current article from the news array. It is definitely not nil, since I assigned the default value of the link when parsing.
        let url = (interactor?.news[indexPath.row].articleUrl)!
        // Initialize the WebViewController class with a link.
        let destination = WebViewController(url)
        
        // Call the routeTo method on the interactor to add a new screen to the stack of screens.
        interactor?
            .routeTo(NewsModel.Navigation.Request(destination: destination))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Set cell fixed height.
        return NewsConstants.newsTableRowsHeight
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Create the "Share" action.
        let shareAction = UIContextualAction(style: .normal, title: "Share") {
            [weak self] _,
            _,
            completion in
            
            // Use guard for security, to monitor the controller and handle errors when accessing the news array.
            guard let self = self, let article = self.interactor?.news[indexPath.row] else {
                completion(false)
                return
            }
            
            // Call the shareArticle method on the interactor and pass the current article there.
            self.interactor?.shareArticle(NewsModel.Share.Request(article: article))
            
            completion(true)
        }
        
        shareAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [shareAction])
    }
}

// MARK: - UIScrollViewDelegate
extension NewsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // Check that the user has scrolled to the end of the table and call the loadMoreNews method on the interactor to load the next pages with news.
        if offsetY > contentHeight - height - NewsConstants.newsTableScrollDist {
            interactor?.loadMoreNews(NewsModel.MoreNews.Request())
        }
    }
}
