//
//  Mapper.swift
//  TestProject
//
//  Created by Silchenko on 28.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import SwiftyJSON

class Mapper {
    
    static let shared = Mapper()
    let queue = DispatchQueue(label: "com.concurrent.Mapper", attributes: .concurrent)
    
    private init() {}
    
    func parseNews(json: JSON) -> [News] {
        var news = [News]()
        var i = 0
        while json["articles"][i] != JSON.null {
            news.append(self.createNews(from: json["articles"][i]))
            i+=1
        }
        return news
    }
    
    private func createNews(from json: JSON) -> News {
        return News(id: json["source"]["id"].string,
                author: json["author"].string,
                 title: json["title"].string ?? "No title",
           description: json["description"].string ?? "No description",
           publishedAt: json["publishedAt"].string ?? "No date",
               content: json["content"].string ?? "No content",
              imageUrl: json["urlToImage"].string)
    }
}
//24650d0a7d5d4029b6b74c8affd2cb93
