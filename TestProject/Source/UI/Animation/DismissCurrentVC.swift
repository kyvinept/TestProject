//
//  Present.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class DismissCurrentVC: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: Double = 2
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        
        containerView.insertSubview(toView, belowSubview: fromView)
        
        toView.frame = fromView.frame
        toView.alpha = 1
        toView.layoutIfNeeded()
        
        UIView.animate(withDuration: duration, animations: {
            fromView.frame.origin.y += UIScreen.main.bounds.height

        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
