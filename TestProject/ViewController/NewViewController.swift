//
//  NewViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "NewViewController"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
    }
}

extension NewViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}
