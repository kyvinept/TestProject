//
//  DynamicsViewController.swift
//  TestProject
//
//  Created by Silchenko on 20.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol DynamicsViewControllerDelegate: class {
    func backButtonTapped()
}

class DynamicsViewController: BaseViewController {

    weak var delegate: DynamicsViewControllerDelegate?
    @IBOutlet private weak var topNavigationBar: UINavigationBar!
    private var collision: UICollisionBehavior!
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private let barrier1Frame = CGRect(x: 0,
                                       y: 300,
                                   width: 110,
                                  height: 20)
    private let barrier2Frame = CGRect(x: 0,
                                       y: 470,
                                   width: 100,
                                  height: 20)
    private let minSize = 70

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createStatusBar()
        setProperties()
        createDynamicsView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        switch UIDevice.current.orientation {
        case .portrait:
            deleteStatusBar()
            createStatusBar()
        case .landscapeLeft,.landscapeRight:
            deleteStatusBar()
            createStatusBar()
        default:
            break
        }
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
        let barrier1 = UIView(frame: barrier1Frame)
        barrier1.backgroundColor = .red
        collision.addBoundary(withIdentifier: NSString(string: "barrier1"), for: UIBezierPath(rect: barrier1.frame))
        self.view.addSubview(barrier1)
        
        let barrier2 = UIView(frame: CGRect(x: self.view.frame.width - barrier2Frame.width,
                                            y: barrier2Frame.origin.y,
                                        width: barrier2Frame.width,
                                       height: barrier2Frame.height))
        barrier2.backgroundColor = .red
        collision.addBoundary(withIdentifier: NSString(string: "barrier2"), for: UIBezierPath(rect: barrier2.frame))
        self.view.addSubview(barrier2)
    }
    
    private func createDynamicsView() {
        let size = Int(arc4random_uniform(50) + UInt32(minSize))
        let widthScreen = Int(self.view.frame.width)
        let x = Int(arc4random_uniform(UInt32(widthScreen - size)))
        let topFrame = Int(self.topNavigationBar.frame.height + UIApplication.shared.statusBarFrame.height)
        let view = DynamicsView(frame: CGRect(x: x,
                                              y: topFrame,
                                          width: size,
                                         height: size))
        view.delegate = self
        self.view.addSubview(view)
        collision.addItem(view)
        gravity.addItem(view)
        animator.addBehavior(gravity)
    }
}

extension DynamicsViewController: DynamicsViewDelegate {
    
    func viewChangeLocation(view: DynamicsView, translation: CGPoint) {
        gravity.removeItem(view)
        collision.removeItem(view)
        view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        gravity.addItem(view)
        collision.addItem(view)
        animator.removeAllBehaviors()
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
    }
    
    func viewWillDelete(view: DynamicsView) {
        collision.removeItem(view)
        gravity.removeItem(view)
        view.removeFromSuperview()
    }
}

//extension DynamicsViewController: UINavigationControllerDelegate {
//    
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        switch operation {
//        case .pop:
//            return CustomPopAnimator()
//        default:
//            return nil
//        }
//    }
//}

extension DynamicsViewController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
    
    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }
    
    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            return .portrait
        }
    }
}
