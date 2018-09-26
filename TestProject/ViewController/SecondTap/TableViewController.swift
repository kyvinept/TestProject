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
    private var items = [DataModel]()
    private var refresh: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createRefresh()
        createStatusBar()
        getDataForTable()
        registeCell()
        tableView.setEditing(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.reloadData()
        switch UIDevice.current.orientation {
        case .portrait:
            deleteStatusBar()
            createStatusBar()
        case .landscapeLeft, .landscapeRight:
            deleteStatusBar()
            createStatusBar()
        default:
            break
        }
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
        let img = setUrlImage()
        for i in 1...10 {
            let item = DataModel(id: String(i),
                              title: String(i) + " title",
                        description: String(i) + " description",
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
    
    @IBAction func addItemToTable(_ sender: Any) {
        let alert = UIAlertController(title: "Input", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "id"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "title"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "description"
        }
        alert.addAction(UIAlertAction(title: "Input", style: .default, handler: { (_) in
            let id = alert.textFields![0].text!
            let title = alert.textFields![1].text!
            let description = alert.textFields![2].text!
            if id == "" {
                self.showErrorMessage(message: "Empty id field. Try again!")
                return
            }
            if title == "" {
                self.showErrorMessage(message: "Empty title field. Try again!")
                return
            }
            if description == "" {
                self.showErrorMessage(message: "Empty description field. Try again!")
                return
            }
            self.addItem(id: id,
                      title: title,
                description: description)
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
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

extension UIViewController {
    func showErrorMessage(message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
