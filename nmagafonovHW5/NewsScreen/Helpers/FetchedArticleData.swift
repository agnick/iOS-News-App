//
//  FetchedArticleData.swift
//  nmagafonovHW5
//
//  Created by Никита Агафонов on 11.12.2024.
//

import UIKit

// Data struct needed to be transferred to the UI.
struct FetchedArticleData {
    let title: String
    let announce: String
    var image: UIImage?
    let imageUrl: URL?
    let articleUrl: URL
}
