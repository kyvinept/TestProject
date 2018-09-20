//
//  AnimationsViewController.swift
//  TestProject
//
//  Created by Silchenko on 20.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol AnimationsViewControllerDelegate {
    func backButtonTapped()
}

class AnimationsViewController: UIViewController {

    @IBOutlet private weak var topNavigationBar: UINavigationBar!
    var delegate: AnimationsViewControllerDelegate?
    private let size: CGFloat = 100
    private let padding: CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createStatusBar()
        createViews()
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
    
    private func createViews() {
        let view1 = createViewForChangeScale(frame: CGRect(x: padding, y: self.topNavigationBar.frame.height + UIApplication.shared.statusBarFrame.height + padding, width: size, height: size))
        let view2 = createViewWithCAKeyframeAnimation(frame: CGRect(x: padding, y: view1.center.y + view1.frame.height / 2 + padding, width: size, height: size))
        let view3 = createViewWithBlockAnimation(frame: CGRect(x: padding, y: view2.center.y + view2.frame.height / 2 + padding, width: size, height: size))
        let _ = createViewForRotateView(frame: CGRect(x: self.view.center.x - size/2, y: view3.center.y + view3.frame.height / 2 + padding, width: size, height: size))
    }
    
    private func createView(frame: CGRect) -> UIView {
        let newView = UIView(frame: frame)
        newView.backgroundColor = UIColor.randomColor()
        self.view.addSubview(newView)
        return newView
    }
    
    private func createViewForChangeScale(frame: CGRect) -> UIView {
        let newView = createView(frame: frame)

        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.fromValue = 1
        anim.toValue = 0.5
        anim.autoreverses = true
        anim.duration = 2
        anim.repeatCount = .greatestFiniteMagnitude
        newView.layer.add(anim, forKey: "transform.scale")
        return newView
    }
    
    private func createViewForRotateView(frame: CGRect) -> UIView {
        let newView = createView(frame: frame)
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.fromValue = 0.0
        anim.toValue = Double.pi
        anim.autoreverses = true
        anim.duration = 2
        anim.repeatCount = .greatestFiniteMagnitude
        newView.layer.add(anim, forKey: "transform.rotation")
        return newView
    }
    
    private func createViewWithCAKeyframeAnimation(frame: CGRect) -> UIView {
        let newView = createView(frame: frame)
        
        let viewFrame = self.view.frame
        let position = [10 + newView.frame.width/2, viewFrame.width / 2 - 30, viewFrame.width / 2, viewFrame.width / 2 + 30, viewFrame.width - 10 - newView.frame.width / 2]
        let anim = CAKeyframeAnimation(keyPath: "position.x")
        anim.values = position
        anim.autoreverses = true
        anim.duration = 3
        anim.repeatCount = .greatestFiniteMagnitude
        newView.layer.add(anim, forKey: "position.x")
        return newView
    }
    
    private func createViewWithBlockAnimation(frame: CGRect) -> UIView {
        let newView = createView(frame: frame)
        moveViewToRight(view: newView)
        return newView
    }
    
    private func moveViewToRight(view: UIView) {
        UIView.animate(withDuration: 2,
                              delay: 0,
             usingSpringWithDamping: 0.8,
              initialSpringVelocity: 0.1,
                            options: .curveEaseIn,
                         animations: { view.center.x = self.view.frame.width - 10 - view.frame.width / 2 },
                         completion: { _ in self.moveViewToLeft(view: view) })
    }
    
    private func moveViewToLeft(view: UIView) {
        UIView.animate(withDuration: 2,
                              delay: 0,
             usingSpringWithDamping: 0.1,
              initialSpringVelocity: 1,
                            options: .curveEaseOut,
                         animations: { view.center.x = 10 + view.frame.width/2 },
                         completion: { _ in self.moveViewToRight(view: view) })
    }
}

extension AnimationsViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}
