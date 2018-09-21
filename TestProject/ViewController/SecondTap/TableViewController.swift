//
//  ObjectTableViewController.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol TableViewControllerDelegate: class {
    func backButtonTapped()
}

class TableViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    weak var delegate: TableViewControllerDelegate?
    private var items = [Item]()
    private var refresh: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createRefresh()
        createStatusBar()
        getDataForTable()
        registeCell()
        setImage()
    }
    
    private func createRefresh() {
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    @objc func refreshData() {
        items.append(Item(id: "100",
                       title: "100 title",
                 description: "100 description",
                    imageUrl: ""))
        items[items.count-1].imageUrl = "https://images-assets.nasa.gov/image/PIA18033/PIA18033~thumb.jpg"
        tableView.reloadData()
        refresh.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.backButtonTapped()
    }
    
    private func getDataForTable() {
        for i in 1...10 {
            let item = Item(id: String(i),
                         title: String(i) + " title",
                   description: String(i) + " description",
                      imageUrl: "")
            items.append(item)
        }
    }
    
    func setImage() {
        items[0].imageUrl = "https://images-assets.nasa.gov/image/PIA18033/PIA18033~thumb.jpg"
        items[1].imageUrl = "https://www.gettyimages.in/landing/assets/static_content/home/info-tabs3.jpg"
        items[2].imageUrl = "https://www.gettyimages.ie/gi-resources/images/Homepage/Hero/UK/CMS_Creative_453010393_NeonShapes.jpg"
        items[3].imageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAqIftOdn-YQ--soQAab_JqgM_v5Q09LbX6JAqjhDEbShw5f7C-A"
        items[4].imageUrl = "https://cdn0.tnwcdn.com/wp-content/blogs.dir/1/files/2017/12/Screen-Shot-2017-12-04-at-10.39.57-796x447.png"
        items[5].imageUrl = "https://images-assets.nasa.gov/image/PIA18033/PIA18033~thumb.jpg"
        items[6].imageUrl = "https://www.gettyimages.in/landing/assets/static_content/home/info-tabs3.jpg"
        items[7].imageUrl = "https://www.gettyimages.ie/gi-resources/images/Homepage/Hero/UK/CMS_Creative_453010393_NeonShapes.jpg"
        items[8].imageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAqIftOdn-YQ--soQAab_JqgM_v5Q09LbX6JAqjhDEbShw5f7C-A"
        items[9].imageUrl = "https://cdn0.tnwcdn.com/wp-content/blogs.dir/1/files/2017/12/Screen-Shot-2017-12-04-at-10.39.57-796x447.png"
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func registeCell() {
        tableView.register(UINib(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell") as? TableCell
        }
        cell?.idLabel.text = items[indexPath.row].id
        cell?.descriptionLabel.text = items[indexPath.row].description
        cell?.titleLabel.text = items[indexPath.row].title
        Networking.shared.downloadImage(url: items[indexPath.row].imageUrl, cell: cell!, saveImage: saveImage)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    private func saveImage(image: UIImage, cell: TableCell) {
        cell.imgView.image = image
    }
}

extension TableViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}
