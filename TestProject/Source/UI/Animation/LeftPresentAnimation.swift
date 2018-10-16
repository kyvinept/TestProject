//
//  Present.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class LeftPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: Double = 2
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        containerView.addSubview(toView)
        
        let screenWidht = UIScreen.main.bounds.width
        toView.frame.origin.x = screenWidht
        
        UIView.animate(withDuration: duration, animations: {
            toView.frame.origin.x = 0
            fromView.frame.origin.x -= screenWidht
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
