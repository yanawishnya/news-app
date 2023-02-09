//
//  NewsViewModel.swift
//  News
//
//  Created by Барбашина Яна on 05.02.2023.
//

import UIKit

final class NewsViewModel {
    let title: String
    let description: String
    let imageURL: URL?
    var imageData: Data? = nil
    let url: String?
    let publishedAt: String
    let author: String?
    var viewsCount: Int
    
    init(title: String, description: String, imageURL: URL?, url: String?, publishedAt: String, author: String?, viewsCount: Int) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
        self.url = url
        self.publishedAt = publishedAt
        self.author = author
        self.viewsCount = viewsCount
    }
}
