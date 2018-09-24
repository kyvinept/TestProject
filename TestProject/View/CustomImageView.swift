//
//  CustomImageView.swift
//  TestProject
//
//  Created by Silchenko on 24.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol CustomImageViewDelegate: class {
    func viewChangeLocation(imageView: CustomImageView)
    func viewWillChangeLocation(imageView: CustomImageView, translation: CGPoint)
    func viewWillChangeScale(imageView: CustomImageView, scale: CGFloat)
}

class CustomImageView: UIImageView {
    
    weak var delegate: CustomImageViewDelegate?
    
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
    
    private func addGesture() {
        self.isUserInteractionEnabled = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(changeLocation(_:)))
        self.addGestureRecognizer(pan)
        
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(rotateView(_:)))
        self.addGestureRecognizer(rotate)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(changeSize(_:)))
        self.addGestureRecognizer(pinch)
    }
    
    private func changeFrontView(gesture: UIGestureRecognizer) {
        if gesture.state == .began {
            self.superview?.addSubview(self)
        } else if gesture.state == .ended {
            delegate?.viewChangeLocation(imageView: self)
        }
    }
    
    @objc func changeLocation(_ gesture: UIPanGestureRecognizer) {
        changeFrontView(gesture: gesture)
        delegate?.viewWillChangeLocation(imageView: self, translation: gesture.translation(in: self.superview))
        gesture.setTranslation(CGPoint.zero, in: self)
    }
    
    @objc func rotateView(_ gesture: UIRotationGestureRecognizer) {
        changeFrontView(gesture: gesture)
        transform = transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    @objc func changeSize(_ gesture: UIPinchGestureRecognizer) {
        changeFrontView(gesture: gesture)
        delegate?.viewWillChangeScale(imageView: self, scale: gesture.scale)
        gesture.scale = 1
    }
}

extension UIView {
    func setNewLocation(pointCenter: CGPoint) {
        UIView.animate(withDuration: 0.5) {
            self.center = pointCenter
        }
    }
    
    func setNewScaleWithLocation(pointCenter:CGPoint, scale: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            self.center = pointCenter
            self.transform = self.transform.scaledBy(x: scale, y: scale)
        }
    }
}
