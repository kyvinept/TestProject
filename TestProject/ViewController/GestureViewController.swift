//
//  GestureViewController.swift
//  TestProject
//
//  Created by Silchenko on 19.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol GestureViewControllerDelegate {
    func backButtonTapped()
}

class GestureViewController: UIViewController {
    
    var delegate: GestureViewControllerDelegate?
    private let imageUrlArray = ["https://as2.ftcdn.net/jpg/00/75/60/21/500_F_75602131_epMBFuHmvreFJDu4DK2mOzlI0vczSkkw.jpg",
                                 "https://as1.ftcdn.net/jpg/01/00/52/58/500_F_100525844_iy9n7Jh4KJbbOwNCOKnv7koqtejka4H8.jpg"]

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
            let height = CGFloat(arc4random_uniform(UInt32(150)) + 50)
            let resize = imageView.frame.height/height
            imageView.frame.size.height /= resize
            imageView.frame.size.width /= resize
            imageView.contentMode = .scaleAspectFit
            let sizeView = UIScreen.main.bounds
            imageView.frame.origin.x = CGFloat(arc4random_uniform(UInt32(sizeView.width - imageView.frame.width)))
            imageView.frame.origin.y = CGFloat(arc4random_uniform(UInt32(sizeView.height - imageView.frame.height - self.navigationController!.navigationBar.frame.height - self.tabBarController!.tabBar.frame.height))) + self.navigationController!.navigationBar.frame.height
            self.view.addSubview(imageView)
        }
    }
}

extension GestureViewController: CustomImageViewDelegate {
    
    func viewChangeLocation(imageView: CustomImageView) {
        for view in view.subviews {
            if view is CustomImageView && view != imageView {
                if view.frame.intersects(imageView.frame) {
                    let height = view.center.y - imageView.center.y
                    let width = view.center.x - imageView.center.x
                    if abs(height) > abs(width) {
                        if height/abs(height) < 0 {
                            view.setNewLocation(pointCenter: CGPoint(x: view.center.x, y: imageView.frame.origin.y - view.frame.height / 2))
                        } else {
                            view.setNewLocation(pointCenter: CGPoint(x: view.center.x, y: imageView.frame.origin.y + imageView.frame.height + view.frame.height / 2))
                        }
                    } else {
                        if height/abs(height) > 0 {
                            view.setNewLocation(pointCenter: CGPoint(x: imageView.frame.origin.x - view.frame.width / 2, y: view.center.y))
                        } else {
                            view.setNewLocation(pointCenter: CGPoint(x: imageView.frame.origin.x + imageView.frame.width + view.frame.width / 2, y: view.center.y))
                        }
                    }
                }
            }
        }
    }
}

extension GestureViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}
