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
    
    private func createRefresh() {
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.addSubview(refresh)
    }
    
    @objc func refreshData() {
        items.append(DataModel(id: "100 wejfwen glew gelw gnelw nwelg",
                       title: "100 title wejfwen glew gelw gnelw nwelgk enwl gnwe lgwkenlewn glwen glwek gnweg nwelkgn welgnwlgeqwegp kw[pg we glewkg wel;g kweg",
                       description: "100 description wejfwen glew gelw gnelw nwelgk enwl gnwe lgwkenlewn glwen glwek gnweg nwelkgn welgnwlgeqwegp kw[pg we glewkg wel;g kweg ",
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
        let img = setUrlImage()
        for i in 1...10 {
            let item = DataModel(id: String(i),
                              title: String(i) + " title",
                        description: String(i) + " description",
                           imageUrl: img[i-1])
            item.delegate = self
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
        cell?.setProperties(model: viewModel)
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
                                         image: data.image ?? UIImage(named: "image"))
        return viewModel
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
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
    
    func swipeCellToDelete(viewModelCell: CustomCellViewModel) {
        guard let index = items.index(where: { $0.id == viewModelCell.id }) else { return }
        items.remove(at: index)
        tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .fade)
    }
}

extension TableViewController: DataModelDelegate {
    
    func imageDownloadFinished(id: String) {
        let index = items.index { $0.id == id }!
        DispatchQueue.main.async {
            let visibleCountCell = self.tableView.visibleCells.count
            if visibleCountCell <= index {
                return
            }
            let customCell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as! CustomCell
            customCell.setProperties(model: self.createViewModel(data: self.items[index]))
        }
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
