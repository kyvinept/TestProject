//
//  Item.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class DataModel: Codable {
    
    enum Data : CodingKey{
        case id
        case title
        case description
        case imageUrl
    }
    
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
    
    required init(from decoder: Decoder) throws {
        let decoder = try decoder.container(keyedBy: Data.self)
        self.id = try decoder.decode(String.self, forKey: .id)
        self.title = try decoder.decode(String.self, forKey: .title)
        self.description = try decoder.decode(String.self, forKey: .description)
        self.imageUrl = try decoder.decode(String.self, forKey: .imageUrl)
    }
    
    private func getImage() {
        NetworkingManager.shared.downloadImage(url: imageUrl) { img in
            self.image = img
        }
    }
}

extension DataModel {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DataModel.Data.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(imageUrl, forKey: .imageUrl)
    }
}
