//
//  CategoryViewController.swift
//  TestProject
//
//  Created by Silchenko on 01.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol CategoryViewControllerDelegate: class {
    func categoryWasSelected(category: String)
}

class CategoryViewController: UITableViewController {
    
    private let category = ["Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]
    weak var delegate: CategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = NSLocalizedString(category[indexPath.row], comment: "") 
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.categoryWasSelected(category: category[indexPath.row].lowercased())
        dismiss(animated: true, completion: nil)
    }
}
