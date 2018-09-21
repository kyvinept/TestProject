//
//  DynamicsView.swift
//  TestProject
//
//  Created by Silchenko on 20.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol DynamicsViewDelegate: class {
    func viewWillDelete(view: DynamicsView)
    func viewChangeLocation(view: DynamicsView, translation: CGPoint)
}

class DynamicsView: UIView {
    
    weak var delegate: DynamicsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.randomColor()
        setGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(changeLocation(_:)))
        self.addGestureRecognizer(pan)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(doubleTapToDelete(_:)))
        tap2.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap2)
    }
    
    @objc func doubleTapToDelete(_ gesture: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.1
        }) { _ in
            self.delegate?.viewWillDelete(view: self)
        }
    }
    
    @objc func changeLocation(_ gesture: UIPanGestureRecognizer) {
        delegate?.viewChangeLocation(view: self, translation: gesture.translation(in:superview!))
        gesture.setTranslation(CGPoint.zero, in: self)
    }

    func setNeedsProperties() -> UIDynamicItemBehavior {
        let itemBehaviour = UIDynamicItemBehavior(items: [self])
        switch arc4random_uniform(5) {
        case 0:
            itemBehaviour.elasticity = 0.9
            print("elasticity")
        case 1:
            itemBehaviour.friction = 2
            print("friction")
        case 2:
            itemBehaviour.density = 3
            print("density")
        case 3:
            itemBehaviour.resistance = 2
            print("resistance")
        case 4:
            itemBehaviour.angularResistance = 60
            print("angularResistance")
        default:
            break
        }
        itemBehaviour.elasticity = 0.6
        return itemBehaviour
    }
}
