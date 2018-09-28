//
//  Networking.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import SwiftyJSON

class NetworkingManager {
    
    static let shared = NetworkingManager()
    private let url = "https://newsapi.org/v2/top-headlines?"
    private let apiKey = "24650d0a7d5d4029b6b74c8affd2cb93"
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
    
    func receiveData(country: Country, saveNews: @escaping ([News]) -> ()) {
        let urlString = url + "country=" + country.rawValue + "&apiKey=" + apiKey
        guard let url = URL(string: urlString) else { return }
        
        downloadDataFromServer(url: url, saveNews: saveNews)
    }
    
    func receiveData(category: Category, saveNews: @escaping ([News]) -> ()) {
        let urlString = url + "category=" + category.rawValue + "&apiKey=" + apiKey
        guard let url = URL(string: urlString) else { return }
        
        downloadDataFromServer(url: url, saveNews: saveNews)
    }
    
    private func downloadDataFromServer(url: URL, saveNews: @escaping ([News]) -> ()) {
        let session = URLSession.shared
        session.dataTask(with: url) { (data, responce, error) in
            guard let data = data else { return }
            let json = try? JSON(data: data)
            self.receiveNews(json: json!, saveNews: saveNews)
        }.resume()
    }
    
    private func receiveNews(json: JSON, saveNews: @escaping ([News]) -> ()) {
        let news = Mapper.shared.parseNews(json: json)
        saveNews(news)
    }
    
    enum Category: String {
        case business
        case entertainment
        case general
        case health
        case science
        case sports
        case technology
    }
    
    enum Country: String {
        case ae
        case ar
        case at
        case au
        case be
        case bg
        case br
        case ca
        case ch
        case cn
        case co
        case cu
        case cz
        case de
        case eg
        case fr
        case gb
        case gr
        case hk
        case hu
        case id
        case ie
        case il
        case it
        case jp
        case kr
        case lt
        case lv
        case ma
        case mx
        case my
        case ng
        case nl
        case no
        case nz
        case ph
        case pl
        case pt
        case ro
        case rs
        case ru
        case sa
        case se
        case sg
        case si
        case sk
        case th
        case tr
        case tw
        case ua
        case us
        case ve
        case za
    }
}
