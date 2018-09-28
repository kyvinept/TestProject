//
//  ImageCell.swift
//  TestProject
//
//  Created by Silchenko on 24.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: UIImageView!
    
    func configure(model: ImageCellViewModel) {
        imageView.image = model.image
        imageView.contentMode = .scaleAspectFit
        
        self.layer.borderColor = model.borderColor
        self.layer.borderWidth = model.borderWidth
    }
}
