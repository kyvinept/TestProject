//
//  ObjectTableViewController.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class TableViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    private var items = [DataModel]()
    private var refresh: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createBackButton()
        createAddButton()
        createRefresh()
        createStatusBar()
        getDataForTable()
        registeCell()
        tableView.setEditing(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.reloadData()
    }
    
    private func createAddButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = button
    }
    
    private func createRefresh() {
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    @objc func refreshData() {
        tableView.reloadData()
        refresh.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.barTintColor = UIColor(red: 151.0/256,
                                                      green: 195.0/256,
                                                       blue: 1,
                                                      alpha: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.barTintColor = nil
    }
    
    private func getDataForTable() {
        let img = setUrlImage()
        for i in 1...10 {
            let item = DataModel(id: String(i),
                              title: String(i) + " " + NSLocalizedString("title", comment: ""),
                        description: String(i) + " " + NSLocalizedString("description", comment: ""),
                           imageUrl: img[i-1])
            items.append(item)
        }
    }
    
    func setUrlImage() -> [String] {
        var img = [String]()
        img.append("https://images-assets.nasa.gov/image/PIA18033/PIA18033~thumb.jpg")
        img.append("https://www.gettyimages.in/landing/assets/static_content/home/info-tabs3.jpg")
        img.append("https://www.gettyimages.ie/gi-resources/images/Homepage/Hero/UK/CMS_Creative_453010393_NeonShapes.jpg")
        img.append("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAqIftOdn-YQ--soQAab_JqgM_v5Q09LbX6JAqjhDEbShw5f7C-A")
        img.append("https://cdn0.tnwcdn.com/wp-content/blogs.dir/1/files/2017/12/Screen-Shot-2017-12-04-at-10.39.57-796x447.png")
        img.append("https://images-assets.nasa.gov/image/PIA18033/PIA18033~thumb.jpg")
        img.append("https://www.gettyimages.in/landing/assets/static_content/home/info-tabs3.jpg")
        img.append("https://www.gettyimages.ie/gi-resources/images/Homepage/Hero/UK/CMS_Creative_453010393_NeonShapes.jpg")
        img.append("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAqIftOdn-YQ--soQAab_JqgM_v5Q09LbX6JAqjhDEbShw5f7C-A")
        img.append("https://cdn0.tnwcdn.com/wp-content/blogs.dir/1/files/2017/12/Screen-Shot-2017-12-04-at-10.39.57-796x447.png")
        return img
    }
    
    @objc func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("Input", comment: ""), message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("id", comment: "")
        }
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("title", comment: "")
        }
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("description", comment: "")
        }
        alert.addAction(UIAlertAction(title: NSLocalizedString("Input", comment: ""), style: .default, handler: { (_) in
            let id = alert.textFields![0].text!
            let title = alert.textFields![1].text!
            let description = alert.textFields![2].text!
            if id == "" {
                self.showErrorMessage(message: NSLocalizedString("Empty id field. Try again!", comment: ""))
                return
            }
            if title == "" {
                self.showErrorMessage(message: NSLocalizedString("Empty title field. Try again!", comment: ""))
                return
            }
            if description == "" {
                self.showErrorMessage(message: NSLocalizedString("Empty description field. Try again!", comment: ""))
                return
            }
            self.addItem(id: id,
                      title: title,
                description: description)
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addItem(id: String, title: String, description: String) {
        items.append(DataModel(id: id,
                            title: title,
                      description: description,
                         imageUrl: "https://images-assets.nasa.gov/image/PIA18033/PIA18033~thumb.jpg"))
        tableView.reloadData()
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func registeCell() {
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CustomCell
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell") as? CustomCell
        }
        let viewModel = createViewModel(data: items[indexPath.row])
        cell?.configure(model: viewModel)
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func createViewModel(data: DataModel) -> CustomCellViewModel {
        let viewModel = CustomCellViewModel(id: data.id,
                                       idColor: .black,
                                         title: data.title,
                                    titleColor: .black,
                                   description: data.description,
                              descriptionColor: .black,
                                      imageUrl: data.imageUrl,
                                         image: data.image)
        return viewModel
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        items.insert(items.remove(at: sourceIndexPath.row), at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
}

extension TableViewController: CustomCellDelegate {
    
    func deleteButtonTapped(view: CustomCell) {
        guard let indexPath = tableView.indexPath(for: view) else { return }
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension UIViewController {
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
