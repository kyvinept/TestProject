//
//  Networking.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

protocol NetworkRequestBuilderProtocol: class {
    func buildGetCountryRequest(country: NetworkingManager.Country, currentCountNews: Int) -> URL?
    func buildGetCategoryRequest(category: NetworkingManager.Category, currentCountNews: Int) -> URL?
    func buildGetQueryRequest(query: String, currentCountNews: Int) -> URL?

}

class NetworkingManager {
    
    static let shared = NetworkingManager()
    private let concurrent = DispatchQueue(label: "com.concurrent.Networking", attributes: .concurrent)
    private let request = NetworkRequestBuilder()
    
    private init() { }
    
    func downloadImage(url: String, saveImage: @escaping (UIImage) -> ()) {
        concurrent.async {
            guard let url = URL(string: url) else { return }
            let data = try? Data(contentsOf: url)
            guard let imageData = data, let image = UIImage(data: imageData) else { return }
            saveImage(image)
        }
    }
    
    func receiveData(country: Country, currentCountNews: Int, saveNews: @escaping ([News]) -> (), requestFailed: @escaping (URL) -> ()) {
        guard let url = request.buildGetCountryRequest(country: country, currentCountNews: currentCountNews) else { return }
        downloadDataFromServer(url: url,
                          saveNews: saveNews,
                     requestFailed: requestFailed)
    }
    
    func receiveData(category: Category, currentCountNews: Int, saveNews: @escaping ([News]) -> (), requestFailed: @escaping (URL) -> ()) {
        guard let url = request.buildGetCategoryRequest(category: category, currentCountNews: currentCountNews) else { return }
        downloadDataFromServer(url: url,
                          saveNews: saveNews,
                     requestFailed: requestFailed)
    }
    
    func receiveData(query: String, currentCountNews: Int, saveNews: @escaping ([News]) -> (), requestFailed: @escaping (URL) -> ()) {
        guard let url = request.buildGetQueryRequest(query: query, currentCountNews: currentCountNews) else { return }
        downloadDataFromServer(url: url,
                          saveNews: saveNews,
                     requestFailed: requestFailed)
    }
    
    func receiveData(from url: URL, saveNews: @escaping ([News]) -> (), requestFailed: @escaping (URL) -> ()) {
        downloadDataFromServer(url: url,
                          saveNews: saveNews,
                     requestFailed: requestFailed)
    }
    
    private func downloadDataFromServer(url: URL, saveNews: @escaping ([News]) -> (), requestFailed: @escaping (URL) -> ()) {
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                self.receiveNews(json: json, saveNews: saveNews)
            case .failure(_):
                requestFailed(url)
            }
        }
    }
    
    func receiveNews(json: JSON, saveNews: @escaping ([News]) -> ()) {
        let news = Mapper.shared.parseNews(json: json)
        saveNews(news)
    }
   
    enum SearchType: String {
        case category
        case country
        case query
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
