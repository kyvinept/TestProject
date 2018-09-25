//
//  BigImageShowView.swift
//  TestProject
//
//  Created by Silchenko on 24.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class BigImageShowView: UIImageView {
    
    private let maxWidth: CGFloat = 1200
    private var minWidth: CGFloat = 200
    private var sizeScreen: CGRect!
    
    override init(image: UIImage?) {
        super.init(image: image)
        setGestures()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setGestures()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        minWidth = frame.width
        setGestures()
    }
    
    private func setGestures() {
        sizeScreen = UIScreen.main.bounds
        self.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(changeScale(_:)))
        self.addGestureRecognizer(pinch)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panImageView(_:)))
        self.addGestureRecognizer(pan)
    }
    
    @objc func panImageView(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        if self.frame.origin.x + translation.x >= 0 || self.frame.origin.x + self.frame.width + translation.x <= sizeScreen.width {
            return
        } else {
            center = CGPoint(x: center.x + translation.x, y: center.y)
        }
        if self.frame.origin.y + translation.y >= 0 || self.frame.origin.y + self.frame.height + translation.y <= sizeScreen.height {
            return
        } else {
            center = CGPoint(x: center.x, y: center.y + translation.y)
        }
        gesture.setTranslation(CGPoint.zero, in: self)
    }
    
    @objc func changeScale(_ gesture: UIPinchGestureRecognizer) {
        if frame.width <= minWidth && gesture.scale < 1 {
            self.transform = CGAffineTransform.identity
            return
        }
        self.transform = transform.scaledBy(x: gesture.scale, y: gesture.scale)
        center = CGPoint(x: sizeScreen.width / 2, y: sizeScreen.height / 2)
        print(self.frame.origin.y)
        gesture.scale = 1
    }
}
