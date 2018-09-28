//
//  FourthViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class FourthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("FourthViewController", comment: "")
        self.navigationController?.delegate = self
    }
}

extension FourthViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return AnimationFromRightCorner()
        default:
            return nil
        }
    }
}

extension FourthViewController: NewViewControllerDelegate {
    
    func backButtonTapped() {
        self.navigationController?.delegate = self
    }
}

