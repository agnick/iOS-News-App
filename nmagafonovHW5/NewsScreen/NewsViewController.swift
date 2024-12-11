//
//  NewsViewController.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

class NewsViewController: UIViewController {
    // MARK: - Enums
    enum NewsConstants {
        // NewsTableView settings.
        static let newsTableViewTop: CGFloat = 10
        static let newsTableViewBottom: CGFloat = 10
        static let newsTableViewLeading: CGFloat = 10
        static let newsTableViewTrailing: CGFloat = 10
    }
    
    // MARK: - Variables
    private let interactor: NewsBusinessLogic
    
    // UI components.
    private let newsTableView: UITableView = UITableView(frame: .zero)
    
    // MARK: - Lifecycle
    init(interactor: NewsBusinessLogic) {
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
    }
    
    // MARK: - Public Methods
    func displayStart() {}
    
    func displayOther() {}
    
    // MARK: - Private Methods
    private func configureUI() {
        view.backgroundColor = .white
        
        configureNewsTableView()
    }
    
    private func configureNewsTableView() {
        view.addSubview(newsTableView)
        
        newsTableView.backgroundColor = .systemGray
        
        // Set the data source and delegate for the tableView view.
        newsTableView.dataSource = self
        newsTableView.delegate = self
        
        // Register the cell class for reuse.
        newsTableView
            .register(UITableViewCell.self, forCellReuseIdentifier: "NewsCell")
        
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
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "NewsCell",
            for: indexPath
        )
        
        cell.textLabel?.text = "Row \(indexPath)"
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension NewsViewController : UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        print("Selected \(indexPath)")
    }
}
