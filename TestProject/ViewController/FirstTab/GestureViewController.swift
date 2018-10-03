//
//  GestureViewController.swift
//  TestProject
//
//  Created by Silchenko on 19.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol GestureViewControllerDelegate: class {
    func backButtonTapped()
}

class GestureViewController: BaseViewController {
    
    @IBOutlet private weak var topNavigationBar: UINavigationBar!
    weak var delegate: GestureViewControllerDelegate?
    private let imageUrlArray = ["https://as2.ftcdn.net/jpg/00/75/60/21/500_F_75602131_epMBFuHmvreFJDu4DK2mOzlI0vczSkkw.jpg",
                                 "https://as1.ftcdn.net/jpg/01/00/52/58/500_F_100525844_iy9n7Jh4KJbbOwNCOKnv7koqtejka4H8.jpg"]
    private let minWidth: CGFloat = 50
    private let minHeight: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createStatusBar()
        getImages()
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

extension GestureViewController {
    
    private func changeLocationViews() {
        for view in self.view.subviews {
            if view is CustomImageView {
                checkIntersectsViews(imageView: view as! CustomImageView)
            }
        }
    }
    
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
    
    private func addImageToView(image: UIImage) {
        DispatchQueue.main.async {
            let imageView = CustomImageView(image: image)
            imageView.delegate = self
            let height = CGFloat(arc4random_uniform(UInt32(100)) + 50)
            let resize = imageView.frame.height/height
            imageView.tag = 10
            imageView.frame.size.height /= resize
            imageView.frame.size.width /= resize
            imageView.contentMode = .scaleAspectFit
            self.randomPointForView(imageView: imageView)
            self.checkIntersectsViews(imageView: imageView)
            self.view.addSubview(imageView)
        }
    }
    
    private func checkIntersectsViews(imageView: CustomImageView) {
        for view in view.subviews {
            if view is CustomImageView && view != imageView {
                if view.frame.intersects(imageView.frame) {
                    randomPointForView(imageView: imageView)
                    checkIntersectsViews(imageView: imageView)
                }
            }
        }
    }
    
    private func randomPointForView(imageView: CustomImageView) {
        let topFrame = self.topNavigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        let bottomFrame = self.view.frame.height - self.tabBarController!.tabBar.frame.height
        imageView.frame.origin.x = CGFloat(arc4random_uniform(UInt32(UIScreen.main.bounds.width - imageView.frame.width)))
        imageView.frame.origin.y = CGFloat(arc4random_uniform(UInt32(bottomFrame - topFrame - imageView.frame.height)) + UInt32(topFrame))
    }
}

extension GestureViewController: CustomImageViewDelegate {
    
    func viewWillChangeScale(imageView: CustomImageView, scale: CGFloat) {
        imageView.transform = imageView.transform.scaledBy(x: scale, y: scale)
        if imageView.frame.width > self.view.frame.width {
            imageView.frame.size.width = self.view.frame.width
            imageView.frame.origin.x = self.view.frame.origin.x
        }
        if imageView.frame.origin.x < 0 {
            imageView.frame.origin.x = 0
        } else if imageView.frame.origin.x + imageView.frame.width > self.view.frame.width {
            imageView.frame.origin.x = self.view.frame.width - imageView.frame.width
        }
        if imageView.frame.origin.y < topNavigationBar.frame.height + UIApplication.shared.statusBarFrame.height {
            imageView.frame.origin.y = topNavigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        } else if imageView.frame.origin.y + imageView.frame.height > self.view.frame.height - tabBarController!.tabBar.frame.height {
            imageView.frame.origin.y = self.view.frame.height - tabBarController!.tabBar.frame.height - imageView.frame.height
        }
    }
    
    func viewWillChangeLocation(imageView: CustomImageView, translation: CGPoint) {
        imageView.center = CGPoint(x: imageView.center.x + translation.x, y: imageView.center.y + translation.y)
        if imageView.frame.origin.y < topNavigationBar.frame.height + UIApplication.shared.statusBarFrame.height {
            imageView.frame.origin.y = topNavigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        }
        if imageView.frame.origin.y + translation.y + imageView.frame.height > self.view.frame.height - tabBarController!.tabBar.frame.height {
            imageView.frame.origin.y = self.view.frame.height - tabBarController!.tabBar.frame.height - imageView.frame.height
        }
        if imageView.frame.origin.x + translation.x < 0 {
            imageView.frame.origin.x = 0
        }
        if imageView.frame.origin.x + translation.x + imageView.frame.width > self.view.frame.width {
            imageView.frame.origin.x = self.view.frame.width - imageView.frame.width
        }
    }
    
    func viewChangeLocation(imageView: CustomImageView) {
        for view in view.subviews {
            if view is CustomImageView && view != imageView {
                if view.frame.intersects(imageView.frame) {
                    let height = view.center.y - imageView.center.y
                    let width = view.center.x - imageView.center.x
                    setLocationToView(height: height,
                                       width: width,
                                   imageView: imageView,
                                        view: view as! CustomImageView)
                }
            }
        }
    }
    
    private func setLocationToView(height: CGFloat, width: CGFloat, imageView: CustomImageView, view: CustomImageView) {
        if abs(height) > abs(width) {
            if height/abs(height) < 0 {
                changeLocationTop(view: view, imageView: imageView)
            } else {
                changeLocationBottom(view: view, imageView: imageView)
            }
        } else {
            if width/abs(width) < 0 {
                changeLocationLeft(view: view, imageView: imageView)
            } else {
                changeLocationRight(view: view, imageView: imageView)
            }
        }
    }
    
    private func changeLocationTop(view: CustomImageView, imageView: CustomImageView) {
        let topFrame = topNavigationBar.frame.height + UIApplication.shared.statusBarFrame.height
        if imageView.frame.origin.y - view.frame.height > topFrame {
            view.setNewLocation(pointCenter: CGPoint(x: view.center.x, y: imageView.frame.origin.y - view.frame.height / 2))
        } else {
            let scale = (imageView.frame.origin.y - topFrame) / view.frame.height
            if checkFrame(view: view, scale: scale).height < minHeight {
                checkFreeHorizontalSpace(imageView: imageView, view: view)
            } else {
                view.setNewScaleWithLocation(pointCenter: CGPoint(x: view.center.x, y: topFrame + view.frame.height/2 - ((view.frame.height - view.frame.height * scale) / 2)), scale: scale)
            }
        }
    }
    
    private func checkFreeHorizontalSpace(imageView: CustomImageView, view: CustomImageView) {
        if imageView.center.x > self.view.center.x {
            changeLocationLeft(view: view, imageView: imageView)
        }
        else {
            changeLocationRight(view: view, imageView: imageView)
        }
    }
    
    private func changeLocationBottom(view: CustomImageView, imageView: CustomImageView) {
        let bottomFrame = self.view.frame.height - tabBarController!.tabBar.frame.height
        if imageView.frame.origin.y + imageView.frame.height + view.frame.height < bottomFrame {
            view.setNewLocation(pointCenter: CGPoint(x: view.center.x, y: imageView.frame.origin.y + imageView.frame.height + view.frame.height / 2))
        } else {
            let scale = (bottomFrame - (imageView.frame.origin.y + imageView.frame.height)) / view.frame.height
            if checkFrame(view: view, scale: scale).height < minHeight {
                checkFreeHorizontalSpace(imageView: imageView, view: view)
            } else {
                view.setNewScaleWithLocation(pointCenter: CGPoint(x: view.center.x, y: bottomFrame - view.frame.height/2 + ((view.frame.height - view.frame.height * scale) / 2)), scale: scale)
            }
        }
    }
    
    private func changeLocationLeft(view: CustomImageView, imageView: CustomImageView) {
        if imageView.frame.origin.x - view.frame.width > 0 {
            view.setNewLocation(pointCenter: CGPoint(x: imageView.frame.origin.x - view.frame.width / 2, y: view.center.y))
        } else {
            let scale = imageView.frame.origin.x / view.frame.width
            if checkFrame(view: view, scale: scale).width < minWidth {
                checkFreeVerticalSpace(imageView: imageView, view: view)
            } else {
                view.setNewScaleWithLocation(pointCenter: CGPoint(x: view.frame.width / 2 - (view.frame.width - view.frame.width * scale) / 2, y: view.center.y), scale: scale)
            }
        }
    }
    
    private func checkFreeVerticalSpace(imageView: CustomImageView, view: CustomImageView) {
        if imageView.center.y > self.view.center.y {
            changeLocationTop(view: view, imageView: imageView)
        }
        else {
            changeLocationBottom(view: view, imageView: imageView)
        }
    }
    
    private func changeLocationRight(view: CustomImageView, imageView: CustomImageView) {
        if imageView.frame.origin.x + imageView.frame.width + view.frame.width < self.view.frame.width {
            view.setNewLocation(pointCenter: CGPoint(x: imageView.frame.origin.x + imageView.frame.width + view.frame.width / 2, y: view.center.y))
        } else {
            let scale = (self.view.frame.width - (imageView.frame.origin.x + imageView.frame.width)) / view.frame.width
            if checkFrame(view: view, scale: scale).width < minWidth {
                checkFreeVerticalSpace(imageView: imageView, view: view)
            } else {
                view.setNewScaleWithLocation(pointCenter: CGPoint(x: self.view.frame.width - view.frame.width / 2 + (view.frame.width - view.frame.width * scale) / 2, y: view.center.y), scale: scale)
            }
        }
    }
    
    private func checkFrame(view: CustomImageView, scale: CGFloat) -> CGRect {
        let newView = CustomImageView(frame: view.frame)
        newView.transform = newView.transform.scaledBy(x: scale, y: scale)
        return newView.frame
    }
}

//extension GestureViewController: UINavigationControllerDelegate {
//    
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        switch operation {
//        case .pop:
//            return CustomPopAnimator()
//        default:
//            return nil
//        }
//    }
//}

extension GestureViewController {
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }

    open override var shouldAutorotate: Bool {
        get {
            return false
        }
    }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            return .portrait
        }
    }
}
