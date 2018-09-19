//
//  SecondViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var i = ThreadSafeInt(count: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SecondViewController"
        self.navigationController?.delegate = self
        
        threads()
    }
    
    @IBAction func openNewViewController(_ sender: Any) {
        let newVC = UIStoryboard(name: "NewViewController", bundle: nil).instantiateViewController(withIdentifier: "NewViewController") as? NewViewController
        if let newVC = newVC {
            newVC.delegate = self
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    func threads() {
        let q1 = DispatchQueue(label: "q1", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        let q2 = DispatchQueue(label: "q2", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        let q3 = DispatchQueue(label: "q3", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        q1.async {
            for _ in 0..<10 {
                self.i.addValue(1)
                print(String(self.i.count) + " --- q1")
            }
        }
        
        q2.async {
            for _ in 0..<10 {
                self.i.addValue(1)
                print(String(self.i.count) + " --- q2")
            }
        }
        
        q3.async {
            for _ in 0..<10 {
                self.i.addValue(1)
                print(String(self.i.count) + " --- q3")
            }
        }
    }
}

extension SecondViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return CustomPushAnimator()
        default:
            return nil
        }
    }
}

extension SecondViewController: NewViewControllerDelegate {
    
    func backButtonTapped() {
        self.navigationController?.delegate = self
    }
}

