//
//  NetworkRequestBuilder.swift
//  TestProject
//
//  Created by Silchenko on 02.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class NetworkRequestBuilder: NetworkRequestBuilderProtocol {
    
    private let apiKey = "24650d0a7d5d4029b6b74c8affd2cb93"
    private let countOfNewsInData = 20
    
    func buildGetCountryRequest(country: NetworkingManager.Country, currentCountNews: Int) -> URL? {
        return URL(string: SearchMode.topHeadlines.rawValue + "country=" + country.rawValue + returnPageNumber(currentCountNews: currentCountNews) + returnApiKey())
    }
    
    func buildGetCategoryRequest(category: NetworkingManager.Category, currentCountNews: Int) -> URL? {
        return URL(string: SearchMode.topHeadlines.rawValue + "category=" + category.rawValue + returnPageNumber(currentCountNews: currentCountNews) + returnApiKey())
    }
    
    func buildGetQueryRequest(query: String, currentCountNews: Int) -> URL? {
        return URL(string: SearchMode.everything.rawValue + "q=" + query + returnPageNumber(currentCountNews: currentCountNews) + returnApiKey())
    }
    
    func buildRequestForTestApi(withIdItem id: Int? = nil) -> String {
        if let id = id {
            return "https://jsonplaceholder.typicode.com/posts/" + String(id)
        } else {
            return "https://jsonplaceholder.typicode.com/posts"
        }
    }
    
    private func returnPageNumber(currentCountNews: Int) -> String {
        return "&page=" + String(currentCountNews/countOfNewsInData+1)
    }
    
    private func returnApiKey() -> String {
        return "&apiKey=" + apiKey
    }
    
    enum SearchMode: String {
        case topHeadlines = "https://newsapi.org/v2/top-headlines?"
        case everything = "https://newsapi.org/v2/everything?"
    }
}
