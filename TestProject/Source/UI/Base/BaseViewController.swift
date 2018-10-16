//
//  BaseViewController.swift
//  TestProject
//
//  Created by Silchenko on 03.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol NavigationControllerDelegate: class {
    func backButtonTapped()
}

class BaseViewController: UIViewController {
    
    weak var delegate: NavigationControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func createBackButton() {
        let button = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = button
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
        delegate?.backButtonTapped()
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
