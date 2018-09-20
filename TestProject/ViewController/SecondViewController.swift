//
//  SecondViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    private let queue = DispatchQueue(label: "l1")
    private var _count:Int = 0
    var count:Int {
        set {
            queue.sync {
                self._count = newValue
            }
        }
        get {
            var i = 0
            queue.sync {
                i = _count
            }
            return i
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SecondViewController"
        self.navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        count = 0
        let q1 = DispatchQueue(label: "q1", attributes: .concurrent)
        let q2 = DispatchQueue(label: "q2", attributes: .concurrent)
//        let q3 = DispatchQueue(label: "q3", attributes: .concurrent)
        
        q1.async {
            for _ in 0..<10 {
                self.count+=1
                print(self.count)
            }
        }
        
        q2.async {
            for _ in 0..<10 {
                self.count+=1
                print(self.count)
            }
        }
        
//        q3.async {
//            for _ in 0..<10 {
//                self.count+=1
//                print(String(self.count) + " --- q3")
//            }
//        }
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

