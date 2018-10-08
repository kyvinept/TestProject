//
//  SaveDataController.swift
//  TestProject
//
//  Created by Silchenko on 04.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class SaveDataController: BaseViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createBackButton()
        saveDataToUserDefaults()
    }
    
    private func saveDataToUserDefaults() {
        let data = DataModel(id: "1",
                          title: "Title",
                    description: "Description",
                       imageUrl: "/url")
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: "data")
        }
    }
    
    @IBAction func saveDataButtonTapped(_ sender: Any) {
        guard let userData = UserDefaults.standard.data(forKey: "data"),
              let data = try? JSONDecoder().decode(DataModel.self, from: userData)
        else { return }
        
        let alert = UIAlertController(title: data.title, message: data.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
