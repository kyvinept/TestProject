//
//  ThirdViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
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
        self.title = "ThirdViewController"
        self.navigationController?.delegate = self
        threads()
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

extension ThirdViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return AnimationFromRightCorner()
        default:
            return nil
        }
    }
}

extension ThirdViewController: NewViewControllerDelegate {
    
    func backButtonTapped() {
        self.navigationController?.delegate = self
    }
}

