//
//  Networking.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class Networking {
    
    static let shared = Networking()
    private let concurrent = DispatchQueue(label: "com.concurrent.Networking", attributes: .concurrent)
    
    private init() { }
    
    func downloadImage(url: String, cell: TableCell, saveImage: @escaping (UIImage, TableCell) -> ()) {
        concurrent.async {
            guard let url = URL(string: url) else { return }
            let data = try? Data(contentsOf: url)
            guard let imageData = data, let image = UIImage(data: imageData) else { return }
            DispatchQueue.main.async {
                saveImage(image, cell)
            }
        }
    }
}
