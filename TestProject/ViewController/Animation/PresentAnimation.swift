//
//  PresentAnimation.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class PresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: Double = 2

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        containerView.addSubview(toView)
        toView.transform = CGAffineTransform(scaleX: 0, y: 0)
        let screenFrame = UIScreen.main.bounds
        toView.center = CGPoint(x: screenFrame.width / 2, y: screenFrame.height / 2)
        
        UIView.animate(withDuration: duration/2) {
            toView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
        
        UIView.animate(withDuration: duration/2, animations: {
            toView.transform = toView.transform.rotated(by: CGFloat.pi)
            toView.transform = CGAffineTransform.identity
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
