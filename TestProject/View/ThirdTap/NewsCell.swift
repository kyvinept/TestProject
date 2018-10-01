//
//  NewsCell.swift
//  TestProject
//
//  Created by Silchenko on 28.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!

    func configure(model: NewsCellViewModel) {
        titleLabel.text = model.title
        titleLabel.textColor = model.titleColor
        
        timeLabel.text = model.time
        timeLabel.textColor = model.timeColor
        
        if let image = model.image {
            imgView.image = image
        } else if let url = model.imageUrl {
            imgView.image = UIImage(named: "picture")
            imgView.downloadImage(imageUrl: url)
        } else {
            imgView.image = UIImage(named: "picture")
        }
    }
}
