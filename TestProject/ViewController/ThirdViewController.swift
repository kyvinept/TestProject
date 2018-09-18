//
//  ThirdViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ThirdViewController"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
    }
    
    @IBAction func openNewViewController(_ sender: Any) {
        let newVC = UIStoryboard(name: "NewViewController", bundle: nil).instantiateViewController(withIdentifier: "NewViewController")
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}

extension ThirdViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return CustomPushAnimator()
        default:
            return nil
        }
    }
}
