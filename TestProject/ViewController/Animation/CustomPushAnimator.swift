//
//  File.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class CustomPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var duration: TimeInterval = 0.6
    
    override init() {
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        containerView.addSubview(toView)
        toView.alpha = 0.2
        toView.transform = CGAffineTransform(scaleX: 0.7, y: 0.05)
        toView.frame.origin = CGPoint(x: 0, y: 0)
        
        UIView.animate(withDuration: duration, animations: {
            toView.transform = CGAffineTransform.identity
            toView.frame.origin = containerView.frame.origin
            toView.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
