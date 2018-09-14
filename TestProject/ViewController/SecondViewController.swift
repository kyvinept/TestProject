//
//  SecondViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.title = "SecondViewController"
        
    }
    
    @IBAction func openNewViewController(_ sender: Any) {
        let newVC = NewViewController(nibName: "NewView", bundle: nil)
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}

extension SecondViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return CustomAnimator(direction: .Top)
        default:
            return nil
        }
    }
}

