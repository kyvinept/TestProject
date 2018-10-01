//
//  NewsViewController.swift
//  TestProject
//
//  Created by Silchenko on 01.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    private var news: News!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNews()
    }
    
    func configure(news: News) {
        self.news = news
    }
    
    private func showNews() {
        imageView.image = news.image ?? UIImage(named: "picture")
        titleLabel.text = news.title
        descriptionLabel.text = news.description
        authorLabel.text = news.author
        timeLabel.text = news.publishedAt
    }
}
