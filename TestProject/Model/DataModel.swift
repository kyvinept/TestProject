//
//  Item.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class DataModel {
    
    var id: String
    var title: String
    var description: String
    var imageUrl: String
    var image: UIImage?
        
    init(id: String, title: String, description: String, imageUrl: String, image: UIImage? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.image = image
        if image == nil {
            getImage()
        }
    }
    
    private func getImage() {
        NetworkingManager.shared.downloadImage(url: imageUrl) { img in
            self.image = img
        }
    }
}
