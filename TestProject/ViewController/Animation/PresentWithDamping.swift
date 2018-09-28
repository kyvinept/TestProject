//
//  Present.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class PresentWithDamping: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: Double = 2
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        containerView.addSubview(toView)
        toView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        let screenFrame = UIScreen.main.bounds
        toView.center = CGPoint(x: screenFrame.width / 2, y: screenFrame.height / 2)
        
        UIView.animate(withDuration: duration,
                              delay: 0,
             usingSpringWithDamping: 0.2,
              initialSpringVelocity: 0.01,
                            options: .curveEaseIn,
        animations: {
            toView.transform = CGAffineTransform.identity
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
