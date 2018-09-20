//
//  DynamicsView.swift
//  TestProject
//
//  Created by Silchenko on 20.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol DynamicsViewDelegate {
    func viewWillDelete(view: DynamicsView)
}

class DynamicsView: UIView {
    
    var delegate: DynamicsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.randomColor()
        timeToRemove()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func timeToRemove() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.delegate?.viewWillDelete(view: self)
        }
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
