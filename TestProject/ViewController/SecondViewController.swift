//
//  SecondViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    let lock = DispatchSemaphore(value: 1)
    var _count = 0
    var count: Int {
        get {
            lock.wait()
            defer { lock.signal() }
            return _count
        }
        set {
            lock.wait()
            defer { lock.signal() }
            _count = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SecondViewController"
        setDispatchQuene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
    }
    
    @IBAction func openNewViewController(_ sender: Any) {
        let newVC = UIStoryboard(name: "NewViewController", bundle: nil).instantiateViewController(withIdentifier: "NewViewController")
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func setDispatchQuene() {
        let dq1 = DispatchQueue(label: "1", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        let dq2 = DispatchQueue(label: "2", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)
        let dq3 = DispatchQueue(label: "3", qos: .default, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil)

        dq1.async {
            for _ in 0...10 {
                self.increase()
                print(self.count)
            }
        }
        
        dq2.async {
            for _ in 0...10 {
                self.increase()
                print(self.count)
            }
        }
        
        dq3.async {
            for _ in 0...10 {
                self.increase()
                print(self.count)
            }
        }
    }
    
    func increase() {
        count += 1
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

