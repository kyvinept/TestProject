//
//  DynamicsViewController.swift
//  TestProject
//
//  Created by Silchenko on 20.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol DynamicsViewControllerDelegate {
    func backButtonTapped()
}

class DynamicsViewController: UIViewController {

    var delegate: DynamicsViewControllerDelegate?
    @IBOutlet private weak var topNavigationBar: UINavigationBar!
    private var collision: UICollisionBehavior!
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createStatusBar()
        setProperties()
        createDynamicsView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.backButtonTapped()
    }
    @IBAction func createNewItemButtonTapped(_ sender: Any) {
        createDynamicsView()
    }
}

extension DynamicsViewController {
    
    private func setProperties() {
        animator = UIDynamicAnimator(referenceView: self.view)
        collision = UICollisionBehavior()
        gravity = UIGravityBehavior()
        collision.addBoundary(withIdentifier: NSString(string: "bottomFrame"), for: UIBezierPath(rect: tabBarController!.tabBar.frame))
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        setBarrier()
    }
    
    private func setBarrier() {
        let barrier1 = UIView(frame: CGRect(x: 0, y: 300, width: 110, height: 20))
        barrier1.backgroundColor = .red
        collision.addBoundary(withIdentifier: NSString(string: "barrier1"), for: UIBezierPath(rect: barrier1.frame))
        self.view.addSubview(barrier1)
        
        let barrier2 = UIView(frame: CGRect(x: self.view.frame.width - 90, y: 470, width: 110, height: 20))
        barrier2.backgroundColor = .red
        collision.addBoundary(withIdentifier: NSString(string: "barrier2"), for: UIBezierPath(rect: barrier2.frame))
        self.view.addSubview(barrier2)
    }
    
    private func createDynamicsView() {
        let x = Int(arc4random_uniform(UInt32(self.view.frame.width - 100)))
        let view = DynamicsView(frame: CGRect(x: x, y: 80, width: 100, height: 100))
        view.delegate = self
        self.view.addSubview(view)
        collision.addItem(view)
        gravity.addItem(view)
        animator.addBehavior(gravity)
        animator.addBehavior(view.setNeedsProperties())
    }
}

extension DynamicsViewController: DynamicsViewDelegate {
    
    func viewWillDelete(view: DynamicsView) {
        collision.removeItem(view)
        gravity.removeItem(view)
        view.removeFromSuperview()
    }
}

extension DynamicsViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}
