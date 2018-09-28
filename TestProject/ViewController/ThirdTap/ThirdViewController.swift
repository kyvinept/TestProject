//
//  ThirdViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ThirdViewController", comment: "")
        registerCell()
        receiveNews()
    }
    
    private func receiveNews() {
        //NetworkingManager.shared.receiveData(category: .general, saveNews: saveNews)
        NetworkingManager.shared.receiveData(country: .ru, saveNews: saveNews)
    }
    
    func saveNews(news: [News]) {
        self.news = news
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension ThirdViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func registerCell() {
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsCell
        cell.configure(model: createNewsViewModel(with: news[indexPath.row]))
        return cell
    }

    private func createNewsViewModel(with news: News) -> NewsCellViewModel {
        return NewsCellViewModel(title: news.title,
                            titleColor: .black,
                                  time: news.publishedAt,
                             timeColor: .black,
                                 image: news.image,
                              imageUrl: news.imageUrl)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
