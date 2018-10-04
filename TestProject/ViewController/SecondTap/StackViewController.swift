//
//  StackViewController.swift
//  TestProject
//
//  Created by Silchenko on 26.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class StackViewController: BaseViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createStatusBar()
        createBackButton()
    }
}
