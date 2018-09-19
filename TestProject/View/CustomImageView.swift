//
//  CustomImageView.swift
//  TestProject
//
//  Created by Silchenko on 19.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        addGesture()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGesture()
    }
    
    func addGesture() {
        self.isUserInteractionEnabled = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(changeLocation(_:)))
        self.addGestureRecognizer(pan)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotateView(_:)))
        self.addGestureRecognizer(rotate)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(changeSize(_:)))
        self.addGestureRecognizer(pinch)
    }
    
    @objc func changeLocation(_ gesture: UIPanGestureRecognizer) {
        self.superview!.addSubview(self)
        let translation = gesture.translation(in: self.superview)
        center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: self)
    }
    
    @objc func rotateView(_ gesture: UIRotationGestureRecognizer) {
        self.superview!.addSubview(self)
        transform = transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    @objc func changeSize(_ gesture: UIPinchGestureRecognizer) {
        self.superview!.addSubview(self)
        transform = transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
    }
}
