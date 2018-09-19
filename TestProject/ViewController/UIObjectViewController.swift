//
//  ButtonViewController.swift
//  TestProject
//
//  Created by Silchenko on 18.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol UIObjectViewControllerDelegate {
    func backButtonTapped()
}

class UIObjectViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    private var addToView: UIView?
    var delegate: UIObjectViewControllerDelegate?
    private let imageUrlArray = ["https://as2.ftcdn.net/jpg/00/75/60/21/500_F_75602131_epMBFuHmvreFJDu4DK2mOzlI0vczSkkw.jpg",
                                 "https://as1.ftcdn.net/jpg/01/00/52/58/500_F_100525844_iy9n7Jh4KJbbOwNCOKnv7koqtejka4H8.jpg",
                                 "https://as2.ftcdn.net/jpg/01/37/55/61/500_F_137556122_6deQOCLc8oWDWR3YQZomudzP6EAtETMA.jpg",
                                 "https://as1.ftcdn.net/jpg/01/37/05/00/500_F_137050041_EgQ3qDW0u4Hmi6yQXvYNn5uwhJ9zxg12.jpg",
                                 "https://as2.ftcdn.net/jpg/00/27/71/97/500_F_27719797_7JkyiDu1zvuxpqJshZe9LEU1dvaKJSYH.jpg",
                                 "https://images.pexels.com/photos/34950/pexels-photo.jpg?auto=compress&cs=tinysrgb&h=350"]
    private let leftConstraintConstant: CGFloat = 20
    private let rightConstraintConstant: CGFloat = 20
    private let topConstraintConstant: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createStatusBar()
        createElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollViewSizeSet(scrollView: scrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewSizeSet(scrollView: scrollView)
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

extension UIObjectViewController {
    
    private func getImages() {
        for url in imageUrlArray {
            if let url = URL(string: url) {
                downloadImage(url: url)
            }
        }
    }
    
    private func downloadImage(url: URL) {
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url)
            guard let imageData = data else { return }
            guard let image = UIImage(data: imageData) else { return }
            self.addImageToView(image: image)
        }
    }
}

extension UIObjectViewController {
    
    private func createElements() {
        addToView = scrollView
        for _ in 1...8 {
            let randomHeight = CGFloat(arc4random_uniform(200) + 50)
            let randomWidth = CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width - 100 - leftConstraintConstant - rightConstraintConstant)) + 100)
            switch Int(arc4random_uniform(2)) {
            case 0:
                addToView = createButton(widthSize: randomWidth,
                                        heightSize: randomHeight,
                                            toItem: addToView!)
            case 1:
                addToView = createStar(widthSize: randomWidth,
                                      heightSize: randomHeight,
                                          toItem: addToView!)
                break
            default:
                break
            }
        }
        getImages()
    }
    
    private func createStar(widthSize: CGFloat, heightSize: CGFloat, toItem: UIView) -> UIView {
        let star = StarView(frame: CGRect(x: 0,
                                          y: 0,
                                      width: widthSize,
                                     height: heightSize))
        star.backgroundColor = UIColor.randomColor()
        star.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(star)
        let constraints = setConstraints(object: star,
                                       toObject: toItem,
                                      widthSize: widthSize,
                                     heightSize: heightSize,
                                   toLeftObject: scrollView,
                                   leftConstant: leftConstraintConstant,
                                    topConstant: topConstraintConstant)
        scrollView.addConstraints(constraints)
        return star
    }
    
    private func createButton(widthSize: CGFloat, heightSize: CGFloat, toItem: UIView) -> UIView {
        let button = UIButton()
        button.setImage(UIImage(named: "star"), for: .normal)
        button.setTitle("Button", for: .normal)
        switch arc4random_uniform(2) {
        case 1:
            button.semanticContentAttribute = .forceRightToLeft
        case 2:
            button.semanticContentAttribute = .forceLeftToRight
        default:
            break
        }
        button.backgroundColor = UIColor.randomColor()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self,
                         action: #selector(newButtonTapped),
                            for: .touchUpInside)
        scrollView.addSubview(button)
        let constraints = setConstraints(object: button,
                                       toObject: toItem,
                                      widthSize: widthSize,
                                     heightSize: heightSize,
                                   toLeftObject: scrollView,
                                   leftConstant: leftConstraintConstant,
                                    topConstant: topConstraintConstant)
        scrollView.addConstraints(constraints)
        return button
    }
    
    @objc func newButtonTapped() {
        let alert = UIAlertController(title: "",
                                    message: "Button was tapped",
                             preferredStyle: .alert)
        self.present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func addImageToView(image: UIImage) {
        DispatchQueue.main.sync {
            let imageView = UIImageView(image: image)
            let height = CGFloat(arc4random_uniform(UInt32(150)) + 50)
            let resize = imageView.frame.height/height
            imageView.frame.size.height /= resize
            imageView.frame.size.width /= resize
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.scrollView.addSubview(imageView)
            let constraints = setConstraints(object: imageView,
                                           toObject: self.addToView ?? self.scrollView,
                                          widthSize: imageView.frame.width,
                                         heightSize: imageView.frame.height,
                                       toLeftObject: scrollView,
                                       leftConstant: leftConstraintConstant,
                                        topConstant: topConstraintConstant)
            scrollView.addConstraints(constraints)
            addToView = imageView
        }
    }
}

extension UIObjectViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}

extension UIViewController {
    
    func createStatusBar() {
        let statusBarView = UIView(frame: CGRect(x: 0,
                                                 y: 0,
                                             width: view.frame.size.width,
                                            height: UIApplication.shared.statusBarFrame.height))
        statusBarView.backgroundColor = UIColor.white
        statusBarView.alpha = 0.68
        view.addSubview(statusBarView)
    }
    
    func setConstraints(object: UIView, toObject: UIView, widthSize: CGFloat, toLeftObject: UIView, leftConstant: CGFloat, topConstant: CGFloat) -> [NSLayoutConstraint] {
        let left = NSLayoutConstraint(item: object,
                                 attribute: NSLayoutAttribute.left,
                                 relatedBy: NSLayoutRelation.equal,
                                    toItem: toLeftObject,
                                 attribute: NSLayoutAttribute.left,
                                multiplier: 1,
                                  constant: leftConstant)
        let top = NSLayoutConstraint(item: object,
                                attribute: NSLayoutAttribute.top,
                                relatedBy: NSLayoutRelation.equal,
                                   toItem: toObject,
                                attribute: NSLayoutAttribute.bottom,
                               multiplier: 1,
                                 constant: topConstant)
        let width = NSLayoutConstraint(item: object,
                                  attribute: NSLayoutAttribute.width,
                                  relatedBy: NSLayoutRelation.equal,
                                     toItem: nil,
                                  attribute: NSLayoutAttribute.notAnAttribute,
                                 multiplier: 1,
                                   constant: widthSize)
        return [left, top, width]
    }
    
    func setConstraints(object: UIView, toObject: UIView, widthSize: CGFloat, heightSize: CGFloat, toLeftObject: UIView, leftConstant: CGFloat, topConstant: CGFloat) -> [NSLayoutConstraint] {
        var constraints = setConstraints(object: object,
                                       toObject: toObject,
                                      widthSize: widthSize,
                                   toLeftObject: toLeftObject,
                                   leftConstant: leftConstant,
                                    topConstant: topConstant)
        let height = NSLayoutConstraint(item: object,
                                   attribute: NSLayoutAttribute.height,
                                   relatedBy: NSLayoutRelation.equal,
                                      toItem: nil,
                                   attribute: NSLayoutAttribute.notAnAttribute,
                                  multiplier: 1,
                                    constant: heightSize)
        constraints.append(height)
        return constraints
    }
    
    func scrollViewSizeSet(scrollView: UIScrollView){
        var contentRect = CGRect.zero
        for view in scrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        scrollView.contentSize.height = contentRect.size.height
    }
}
