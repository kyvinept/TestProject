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
    func buildRequestForTestApi(withIdItem id: Int) -> String
    func buildRequestForTestApi() -> String
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
    
    func receiveNews(fromCountry country: Country, currentCountNews: Int, successBlock: @escaping ([News]) -> (), failBlock: @escaping (URL) -> ()) {
        guard let url = request.buildGetCountryRequest(country: country, currentCountNews: currentCountNews) else { return }
        downloadDataFromServer(url: url,
                      successBlock: successBlock,
                         failBlock: failBlock)
    }
    
    func receiveNews(fromCategory category: Category, currentCountNews: Int, successBlock: @escaping ([News]) -> (), failBlock: @escaping (URL) -> ()) {
        guard let url = request.buildGetCategoryRequest(category: category, currentCountNews: currentCountNews) else { return }
        downloadDataFromServer(url: url,
                      successBlock: successBlock,
                         failBlock: failBlock)
    }
    
    func receiveNews(withQuery query: String, currentCountNews: Int, successBlock: @escaping ([News]) -> (), failBlock: @escaping (URL) -> ()) {
        guard let url = request.buildGetQueryRequest(query: query, currentCountNews: currentCountNews) else { return }
        downloadDataFromServer(url: url,
                      successBlock: successBlock,
                         failBlock: failBlock)
    }
    
    func receiveNews(fromUrl url: URL, successBlock: @escaping ([News]) -> (), failBlock: @escaping (URL) -> ()) {
        downloadDataFromServer(url: url,
                      successBlock: successBlock,
                         failBlock: failBlock)
    }
    
    private func downloadDataFromServer(url: URL, successBlock: @escaping ([News]) -> (), failBlock: @escaping (URL) -> ()) {
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                self.parseNews(json: json, successBlock: successBlock)
            case .failure(_):
                failBlock(url)
            }
        }
    }
    
    func parseNews(json: JSON, successBlock: @escaping ([News]) -> ()) {
        let news = Mapper.shared.parseNews(json: json)
        successBlock(news)
    }
    
    func receiveItems(withId id: Int, successBlock: @escaping (String) -> (), failBlock: @escaping () -> ()) {
        Alamofire.request(request.buildRequestForTestApi(withIdItem: id))
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                successBlock(String(describing: data))
            case .failure(_):
                failBlock()
            }
        }
    }
    
    func receiveItems(successBlock: @escaping (String) -> (), failBlock: @escaping () -> ()) {
        Alamofire.request(request.buildRequestForTestApi())
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                successBlock(String(describing: data))
            case .failure(_):
                failBlock()
            }
        }
    }
    
    func putItem(withId id: Int, title: String, body: String, userId: Int, successBlock: @escaping (String) -> (), failBlock: @escaping () -> ()) {
        let url = request.buildRequestForTestApi(withIdItem: id)
        let parameters: [String : Any] = ["title": title, "body": body, "userId": userId]
        Alamofire.request(url,
                          method: .put,
                      parameters: parameters)
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                successBlock(String(describing: data))
            case .failure(_):
                failBlock()
            }
        }
    }
    
    func postItem(title: String, body: String, userId: Int, successBlock: @escaping (String) -> (), failBlock: @escaping () -> ()) {
        let url = request.buildRequestForTestApi()
        let parameters: [String : Any] = ["title": title, "body": body, "userId": userId]
        Alamofire.request(url, method: .post, parameters: parameters)
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                successBlock(String(describing: data))
            case .failure(_):
                failBlock()
            }
        }
    }
    
    func patchItem(withId id: Int, title: String, body: String, userId: Int, successBlock: @escaping (String) -> (), failBlock: @escaping () -> ()) {
        let url = request.buildRequestForTestApi(withIdItem: id)
        let parameters: [String : Any] = ["title": title, "body": body, "userId": userId]
        Alamofire.request(url,
                          method: .patch,
                      parameters: parameters)
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                successBlock(String(describing: data))
            case .failure(_):
                failBlock()
            }
        }
    }
    
    func deleteItem(withId id: Int, successBlock: @escaping () -> (), failBlock: @escaping () -> ()) {
        Alamofire.request(request.buildRequestForTestApi(withIdItem: id), method: .delete)
        .responseJSON { response in
            switch response.result {
            case .success(_):
                successBlock()
            case .failure(_):
                failBlock()
            }
        }
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
