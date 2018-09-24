//
//  Networking.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class NetworkingManager {
    
    static let shared = NetworkingManager()
    private let concurrent = DispatchQueue(label: "com.concurrent.Networking", attributes: .concurrent)
    
    private init() { }
    
    func downloadImage(url: String, saveImage: @escaping (UIImage) -> ()) {
        concurrent.async {
            guard let url = URL(string: url) else { return }
            let data = try? Data(contentsOf: url)
            guard let imageData = data, let image = UIImage(data: imageData) else { return }
            saveImage(image)
        }
    }
}
