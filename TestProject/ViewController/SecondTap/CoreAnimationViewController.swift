//
//  CoreAnimationViewController.swift
//  TestProject
//
//  Created by Silchenko on 26.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol CoreAnimationViewControllerDelegate: class {
    func backButtonTapped()
}

class CoreAnimationViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    private let padding: CGFloat = 10
    private let size: CGFloat = 150
    weak var delegate: CoreAnimationViewControllerDelegate?
    private var height: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createStatusBar()
        createGradientView()
        createBeziePathView()
        createBlurView()
        createCart()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        deleteStatusBar()
        createStatusBar()
        scrollView.contentSize.height = height + size + padding
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.backButtonTapped()
    }
}

extension CoreAnimationViewController {
    
    private func createGradientView() {
        height += padding
        let view = UIView(frame: CGRect(x: padding, y: height, width: size, height: size))
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
        gradientLayer.locations = [0.0, 0.33, 0.66, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.frame = view.frame
        view.layer.addSublayer(gradientLayer)
        scrollView.addSubview(view)
    }
    
    private func createBeziePathView() {
        height += padding*2 + size + size
        let view = UIView(frame: CGRect(x: self.view.frame.width / 2, y: height, width: size, height: size))
        view.backgroundColor = .white
        let path = UIBezierPath()
        path.move(to: CGPoint(x: view.frame.maxX, y: view.frame.maxY))
        path.addQuadCurve(to: CGPoint(x: 0, y: view.frame.maxY), controlPoint: CGPoint(x: view.frame.maxX/2, y: 0))
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.repeatCount = .greatestFiniteMagnitude
        animation.duration = 2.0
        animation.autoreverses = true
        view.layer.add(animation, forKey: "animate along path")
        scrollView.addSubview(view)
    }
    
    private func createBlurView() {
        height += size*2
        let view = UIView(frame: CGRect(x: padding, y: height, width: size, height: size))
        DispatchQueue.global().async {
            let ciInput = CIImage(image: UIImage(named: "image")!)!
            let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputImage": ciInput, "inputRadius": 8])
            let ciOutput = filter?.outputImage
            let ciContext = CIContext(options: nil)
            let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
            DispatchQueue.main.async {
                view.layer.contents = cgImage
                self.scrollView.addSubview(view)
            }
        }
    }
    
    private func createCart() {
        height += size + padding
        let view = UIView(frame: CGRect(x: padding, y: height, width: size, height: size))
        view.layer.backgroundColor = UIColor.yellow.cgColor
        
        var perspective = CATransform3DIdentity
        perspective.m34 = -1 / -500
        view.layer.transform = CATransform3DRotate(perspective, CGFloat.pi, 0, 1, 0)
        
        let anim = CABasicAnimation(keyPath: "transform")
        anim.duration = 3
        anim.fromValue = CATransform3DRotate(perspective, 0, 0, 1, 0)
        anim.toValue = CATransform3DRotate(perspective, CGFloat.pi, 0, 1, 0)
        anim.repeatCount = .greatestFiniteMagnitude
        anim.autoreverses = true
        view.layer.add(anim, forKey: "")
//        view.layer.addSublayer(layer)
        scrollView.addSubview(view)
    }
}

extension CoreAnimationViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}
