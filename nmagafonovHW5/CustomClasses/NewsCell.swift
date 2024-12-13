//
//  NewsCell.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

final class NewsCell: UITableViewCell {
    // MARK: - Enums
    enum NewsCellConstants {
        // Wrap settings.
        static let wrapBackgroundColor: UIColor = .clear
        static let wrapLayerCornerRadius: CGFloat = 10
        static let wrapOffsetV: CGFloat = 5
        static let wrapOffsetH: CGFloat = 10
        
        // ArcticleImage settings.
        
        // ArcticleTitle settings.
        static let articleTitleFontSize: CGFloat = 16
        static let articleTitleLeading: CGFloat = 5
        static let articleTitleBottom: CGFloat = 5
        static let acrticleTitleTrailing: CGFloat = 50
        static let articleTitleNumberOfLines: Int = 0
        static let arcitleTitleTextColor: UIColor = UIColor(hex: "#65c666") ?? .white
        
        // ArcticleAnnounce settings.
        static let articleAnnounceFontSize: CGFloat = 14
        static let articleAnnounceLeading: CGFloat = 5
        static let articleAnnounceBottom: CGFloat = 5
        static let articleAnnounceTrailing: CGFloat = 5
        static let articleAnnounceNumberOfLines: Int = 0
        static let arcitleAnnounceTextColor: UIColor = .white
    }
    
    // MARK: - Variables
    static let reuseId: String = "NewsCell"
    
    // UI Components.
    private let articleImg: CustomImageView = CustomImageView()
    private let articleTitle: UILabel = UILabel()
    private let articleAnnounce: UILabel = UILabel()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(_ article: FetchedArticleData, _ interactor: (NewsBusinessLogic & NewsDataStore)) {
        // Update the cell title and announce.
        articleAnnounce.text = article.title
        articleTitle.text = article.announce
        
        // Checking that the url is not nil.
        if let imageUrl = article.imageUrl {
            // Call the setImage method on image, pass there a link and an interactor for the download request.
            articleImg.setImage(from: imageUrl, interactor: interactor)
        } else {
            articleImg.image = nil
        }
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        selectionStyle = .none
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        let wrap: UIView = UIView()
        addSubview(wrap)
        
        // Wrap settings.
        wrap.backgroundColor = NewsCellConstants.wrapBackgroundColor
        wrap.layer.cornerRadius = NewsCellConstants.wrapLayerCornerRadius
        wrap.layer.masksToBounds = true
        
        // Wrap constraints.
        wrap.pinVertical(to: self, NewsCellConstants.wrapOffsetV)
        wrap.pinHorizontal(to: self, NewsCellConstants.wrapOffsetH)
        
        // Configure other UI components.
        configureArticleImg(wrap)
        configureArticleAnnounce(wrap)
        configureArticleTitle(wrap)
    }
    
    private func configureArticleImg(_ wrap: UIView) {
        wrap.addSubview(articleImg)
        
        // Image settings.
        articleImg.contentMode = .scaleAspectFill
        articleImg.clipsToBounds = true
        
        // Image constraints.
        articleImg.pinTop(to: wrap)
        articleImg.pinLeft(to: wrap)
        articleImg.pinRight(to: wrap)
        articleImg.pinBottom(to: wrap)
    }
    
    private func configureArticleAnnounce(_ wrap: UIView) {
        wrap.addSubview(articleAnnounce)
        
        // Announce settings.
        articleAnnounce.font = .systemFont(ofSize: NewsCellConstants.articleAnnounceFontSize, weight: .medium)
        articleAnnounce.textColor = NewsCellConstants.arcitleAnnounceTextColor
        articleAnnounce.numberOfLines = NewsCellConstants.articleAnnounceNumberOfLines
        articleAnnounce.textAlignment = .justified
        
        // Announce constraints.
        articleAnnounce.pinLeft(to: wrap, NewsCellConstants.articleAnnounceLeading)
        articleAnnounce.pinBottom(to: wrap, NewsCellConstants.articleAnnounceBottom)
        articleAnnounce.pinRight(to: wrap, NewsCellConstants.articleAnnounceTrailing)
    }
    
    private func configureArticleTitle(_ wrap: UIView) {
        wrap.addSubview(articleTitle)
        
        // Title settings.
        articleTitle.font = .systemFont(ofSize: NewsCellConstants.articleTitleFontSize, weight: .bold)
        articleTitle.textColor = NewsCellConstants.arcitleTitleTextColor
        articleTitle.numberOfLines = NewsCellConstants.articleTitleNumberOfLines
        articleTitle.textAlignment = .justified
        
        // Title constraints.
        articleTitle.pinLeft(to: wrap, NewsCellConstants.articleTitleLeading)
        articleTitle.pinBottom(to: articleAnnounce.topAnchor, NewsCellConstants.articleTitleBottom)
        articleTitle.pinRight(to: wrap, NewsCellConstants.acrticleTitleTrailing)
    }
}
