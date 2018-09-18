//
//  Star.swift
//  TestProject
//
//  Created by Silchenko on 18.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class Star: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func customInit() {
        mask(withRect: CGRect(x: 0, y: 0, width: self.frame.width - 50, height: self.frame.height - 50))
    }

    func mask(withRect rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.width / 2, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width * 2 / 3, y: self.frame.height / 3))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height / 3))
        path.addLine(to: CGPoint(x: self.frame.width * 2.2 / 3, y: self.frame.height * 1.8 / 3))
        path.addLine(to: CGPoint(x: self.frame.width * 2.8 / 3, y: self.frame.height))
        path.addLine(to: CGPoint(x: self.frame.width / 2, y: self.frame.height * 2.3 / 3))
        path.addLine(to: CGPoint(x: self.frame.width * 0.1, y: self.frame.height))
        path.addLine(to: CGPoint(x: self.frame.width * 0.8 / 3, y: self.frame.height * 1.8 / 3))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height / 3))
        path.addLine(to: CGPoint(x: self.frame.width / 3, y: self.frame.height / 3))
        path.close()
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
