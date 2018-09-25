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
        self.isUserInteractionEnabled = true
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(changeScale(_:)))
        self.addGestureRecognizer(pinch)
    }
    
    @objc func changeScale(_ gesture: UIPinchGestureRecognizer) {
        if frame.width > maxWidth && gesture.scale > 1 {
            return
        } else if frame.width < minWidth && gesture.scale < 1 {
            return
        }
        self.transform = self.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
    }
}
