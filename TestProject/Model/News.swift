//
//  News.swift
//  TestProject
//
//  Created by Silchenko on 28.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol NewsDelegate: class {
    func imageDownloaded(news: News)
}

class News {
    
    weak var delegate: NewsDelegate?
    var id: String?
    var author: String?
    var title: String
    var descriptionNews: String
    var publishedAt: String
    var content: String

    var imageUrl: String?
    var image: UIImage?
    
    init(id: String?, author: String?, title: String, descriptionNews: String, publishedAt: String, content: String, imageUrl: String?, image: UIImage? = nil) {
        self.id = id
        self.author = author
        self.title = title
        self.descriptionNews = descriptionNews
        self.imageUrl = imageUrl
        self.image = image
        let time = publishedAt.split(separator: "T")
        if time.count == 1 {
            self.publishedAt = publishedAt
        } else {
            self.publishedAt = time[0] + " " + time[1]
        }
        self.publishedAt.removeLast()
        self.content = content
        
        if image == nil {
            getImage()
        }
    }
    
    private func getImage() {
        guard let url = imageUrl else { return }
        NetworkingManager.shared.downloadImage(url: url) { img in
            self.image = img
            self.delegate?.imageDownloaded(news: self)
        }
    }
}
