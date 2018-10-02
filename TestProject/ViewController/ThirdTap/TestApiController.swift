//
//  TestApiController.swift
//  TestProject
//
//  Created by Silchenko on 02.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol TestApiControllerDelegate: class {
    func newsWasDownloaded(news: [News])
}

class TestApiController: UIViewController {
    
    weak var delegate: TestApiControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func showAlertForUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func removeItemButtonTapped(_ sender: Any) {
        NetworkingManager.shared.deleteItem(withId: 1, successfulBlock: {
            self.showAlertForUser(title: "Success", message: "Item with id = 1 was deleted!")
        }) {
            self.showAlertForUser(title: "Error", message: "Item wasn't deleted.")
        }
    }
    
    @IBAction func getItemsButtonTapped(_ sender: Any) {
        NetworkingManager.shared.receiveItems(withId: 1, successfulBlock: { str in
            self.showAlertForUser(title: "Success", message: str)
        }) {
            self.showAlertForUser(title: "Error", message: "Item wasn't deleted.")
        }
    }
    
    @IBAction func putItemButtonTapped(_ sender: Any) {
        NetworkingManager.shared.putItem(withId: 1,
                                          title: "newtitle",
                                           body: "newbody",
                                         userId: 1,
        successfulBlock: { str in
            self.showAlertForUser(title: "Success", message: str)
        }) {
            self.showAlertForUser(title: "Error", message: "Item wasn't deleted.")
        }
    }
    
    @IBAction func postItemButtonTapped(_ sender: Any) {
        NetworkingManager.shared.postItem(withId: nil,
                                           title: "newtitle",
                                            body: "newbody",
                                          userId: 1,
        successfulBlock: { str in
            self.showAlertForUser(title: "Success", message: str)
        }) {
            self.showAlertForUser(title: "Error", message: "Item wasn't deleted.")
        }
    }
    
    @IBAction func patchItemButtonTapped(_ sender: Any) {
        NetworkingManager.shared.patchItem(withId: 1,
                                            title: "newtitle",
                                             body: "newbody",
                                           userId: 1,
        successfulBlock: { str in
            self.showAlertForUser(title: "Success", message: str)
        }) {
            self.showAlertForUser(title: "Error", message: "Item wasn't deleted.")
        }
    }
    
    private func returnNewsToParentVC(news: [News]) {
        delegate?.newsWasDownloaded(news: news)
        self.navigationController?.popViewController(animated: true)
    }
}
