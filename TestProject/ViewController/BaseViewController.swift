//
//  BaseViewController.swift
//  TestProject
//
//  Created by Silchenko on 03.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension BaseViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}
