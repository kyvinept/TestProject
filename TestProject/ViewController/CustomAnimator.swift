//
//  File.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: TimeInterval = 1.0
    var direction: Direction = .Bottom
    
    init(direction: Direction) {
        super.init()
        self.direction = direction
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        containerView.addSubview(toView)
        switch direction {
        case .Left:
            toView.frame = CGRect(x: -containerView.bounds.width, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
        case .Right:
            toView.frame = CGRect(x: containerView.bounds.width, y: 0, width: containerView.bounds.width, height: containerView.bounds.height)
        case .Top:
            toView.frame = CGRect(x: 0, y: -containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height)
        case .Bottom:
            toView.frame = CGRect(x: 0, y: containerView.bounds.height, width: containerView.bounds.width, height: containerView.bounds.height)
        }
        UIView.animate(withDuration: duration, animations: {
            toView.frame = containerView.frame
        }, completion: { _ in
            transitionContext.completeTransition(true)
        } )
    }
    
    enum Direction {
        case Left
        case Right
        case Top
        case Bottom
    }
}
