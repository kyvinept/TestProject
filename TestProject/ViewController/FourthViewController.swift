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
        self.title = "FourthViewController"
        self.navigationController?.delegate = self
    }
    
    @IBAction func openNewViewController(_ sender: Any) {
        let newVC = UIStoryboard(name: "NewViewController", bundle: nil).instantiateViewController(withIdentifier: "NewViewController") as? NewViewController
        if let newVC = newVC {
            newVC.delegate = self
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
}

extension FourthViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return CustomPushAnimator()
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

