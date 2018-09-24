//
//  BigImageShowView.swift
//  TestProject
//
//  Created by Silchenko on 24.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class BigImageShowView: UIImageView {
    
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
        setGestures()
    }
    
    private func setGestures() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchImageView(_:)))
        self.addGestureRecognizer(pinch)
    }
    
    @objc func pinchImageView(_ gesture: UIPinchGestureRecognizer) {
        self.transform = self.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 0
    }
}
