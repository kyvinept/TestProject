//
//  CustomPopAnimation.swift
//  TestProject
//
//  Created by Silchenko on 18.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private var duration: TimeInterval = 0.6
    
    override init() {
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
        
        container.insertSubview(toView, belowSubview: fromView)
        
        let detailView = fromView
        
        toView.alpha = 1
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, animations: {
            detailView.transform = CGAffineTransform(scaleX: 0.5, y: 0.05)
            detailView.frame.origin = CGPoint(x: 0, y: 0)
            detailView.alpha = 0
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
