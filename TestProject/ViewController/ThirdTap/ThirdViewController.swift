//
//  ThirdViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    private var news = [News]()
    private var spinner: UIActivityIndicatorView!
    private var country: NetworkingManager.Country!
    private var refresh: UIRefreshControl!
    private var searchType = NetworkingManager.SearchType.country
    private var newsInRequest = 20
    private var query = ""
    private var category: NetworkingManager.Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ThirdViewController", comment: "")
        registerCell()
        receiveNews()
        createSnipper()
        createRefreshControll()
    }
    
    func errorLoadingData(from url: URL) {
        let alert = UIAlertController(title: "Error",
                                    message: "Check your internet connection",
                             preferredStyle: .alert)
        let button = UIAlertAction(title: "Try again", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
            NetworkingManager.shared.receiveData(from: url,
                                             saveNews: self.saveNews,
                                        requestFailed: self.errorLoadingData)
        }
        alert.addAction(button)
        self.present(alert,
                     animated: true,
                   completion: nil)
    }
    
    private func createSnipper() {
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        spinner.color = UIColor.darkGray
        spinner.hidesWhenStopped = true
        tableView.tableFooterView = spinner
    }
    
    private func createRefreshControll() {
        refresh = UIRefreshControl()
        tableView.addSubview(refresh)
        refresh.tintColor = UIColor.gray
        refresh.addTarget(self,
                          action: #selector(refreshTableView),
                             for: .valueChanged)
    }
    
    @objc func refreshTableView() {
        tableView.reloadData()
        refresh.endRefreshing()
    }
    
    private func receiveNews() {
        guard let location = Locale.current.languageCode else { return }
        if let country = NetworkingManager.Country(rawValue: location) {
            self.country = country
            NetworkingManager.shared.receiveData(country: country,
                                        currentCountNews: news.count,
                                                saveNews: saveNews,
                                           requestFailed: errorLoadingData)
        } else {
            self.country = .us
            NetworkingManager.shared.receiveData(country: country,
                                        currentCountNews: news.count,
                                                saveNews: saveNews,
                                           requestFailed: errorLoadingData)
        }
    }
    
    func saveNews(news: [News]) {
        self.news = news
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func saveAdditionalNews(news: [News]) {
        for n in news {
            self.news.append(n)
        }
        DispatchQueue.main.async {
            if news.count != 0 {
                self.tableView.reloadData()
            }
            self.spinner.stopAnimating()
        }
    }
    
    @IBAction func categoryButtonTapped(_ sender: Any) {
        searchBar.endEditing(true)
        let categoryVC = storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as! CategoryViewController
        categoryVC.modalPresentationStyle = .popover
        categoryVC.delegate = self
        let popover = categoryVC.popoverPresentationController
        popover!.delegate = self
        categoryVC.preferredContentSize = CGSize(width: 200, height: 200)
        popover!.sourceView = self.view
        popover?.backgroundColor = .gray
        popover!.sourceRect = CGRect(x: 0,
                                     y: 0,
                                 width: 100,
                                height: 120)
        self.present(categoryVC,
                     animated: true,
                   completion: nil)
    }
}

extension ThirdViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y + scrollView.frame.height > tableView.contentSize.height) && news.count >= newsInRequest {
            if spinner.isAnimating == true { return }
            spinner.startAnimating()
            switch searchType {
            case .category:
                NetworkingManager.shared.receiveData(category: category,
                                             currentCountNews: news.count,
                                                     saveNews: saveAdditionalNews,
                                                requestFailed: errorLoadingData)
            case .country:
                NetworkingManager.shared.receiveData(country: country,
                                            currentCountNews: news.count,
                                                    saveNews: saveAdditionalNews,
                                               requestFailed: errorLoadingData)
            case .query:
                NetworkingManager.shared.receiveData(query: query,
                                          currentCountNews: news.count,
                                                  saveNews: saveAdditionalNews,
                                             requestFailed: errorLoadingData)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsVC = storyboard?.instantiateViewController(withIdentifier: "NewsViewController") as! NewsViewController
        newsVC.configure(news: news[indexPath.row])
        self.navigationController?.pushViewController(newsVC, animated: true)
    }
    
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

extension ThirdViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        NetworkingManager.shared.receiveData(query: searchBar.text!,
                                  currentCountNews: news.count,
                                          saveNews: saveNews,
                                     requestFailed: errorLoadingData)
        searchType = .query
        query = searchBar.text!
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        let cancelButtonSearchButton = searchBar.value(forKeyPath: "cancelButton") as? UIButton
        cancelButtonSearchButton?.tintColor = UIColor.blue
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = false
        return true
    }
}

extension ThirdViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}

extension ThirdViewController: CategoryViewControllerDelegate {
    
    func didSelectCategory(category: String) {
        NetworkingManager.shared.receiveData(category: NetworkingManager.Category(rawValue: category)!,
                                     currentCountNews: news.count,
                                             saveNews: saveNews,
                                        requestFailed: errorLoadingData)
        searchType = .category
        self.category = NetworkingManager.Category(rawValue: category)!
    }
}
