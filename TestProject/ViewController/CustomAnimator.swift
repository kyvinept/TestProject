//
//  File.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private var duration: TimeInterval = 1.0
    private var direction: Direction
    
    init(direction: Direction) {
        self.direction = direction
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
        switch direction {
        case .left:
            toView.frame = CGRect(x: -containerView.bounds.width, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
        case .right:
            toView.frame = CGRect(x: containerView.bounds.width, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
        case .center:
            toView.transform = CGAffineTransform(scaleX: 0.7, y: 0.05)
            //toView.frame = CGRect(x: 0, y: -containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height)
        case .bottom:
            toView.frame = CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height)
        default:
            break
        }
        UIView.animate(withDuration: duration, animations: {
            toView.transform = CGAffineTransform.identity
            toView.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
    
    enum Direction {
        case left
        case right
        case top
        case bottom
        case center
    }
}
