//
//  ButtonViewController.swift
//  TestProject
//
//  Created by Silchenko on 18.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol ButtonViewControllerDelegate {
    func backButtonTapped()
}

class ButtonViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var delegate: ButtonViewControllerDelegate?
    let imageUrlArray = ["https://as2.ftcdn.net/jpg/00/75/60/21/500_F_75602131_epMBFuHmvreFJDu4DK2mOzlI0vczSkkw.jpg",
                         "https://as1.ftcdn.net/jpg/01/00/52/58/500_F_100525844_iy9n7Jh4KJbbOwNCOKnv7koqtejka4H8.jpg",
                         "https://as2.ftcdn.net/jpg/01/37/55/61/500_F_137556122_6deQOCLc8oWDWR3YQZomudzP6EAtETMA.jpg",
                         "https://as1.ftcdn.net/jpg/01/37/05/00/500_F_137050041_EgQ3qDW0u4Hmi6yQXvYNn5uwhJ9zxg12.jpg",
                         "https://as2.ftcdn.net/jpg/00/27/71/97/500_F_27719797_7JkyiDu1zvuxpqJshZe9LEU1dvaKJSYH.jpg",
                         "https://images.pexels.com/photos/34950/pexels-photo.jpg?auto=compress&cs=tinysrgb&h=350"]

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

extension ButtonViewController {
    
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
            let width = Int(arc4random_uniform(50) + 50)
            let height = Int(arc4random_uniform(50) + 50)
            let x = Int(arc4random_uniform(UInt32(Int(self.view.frame.width) - width)))
            let y = Int(arc4random_uniform(UInt32(Int(self.view.frame.height) - height - 60)) + 60)
            let imageView = UIImageView(frame: CGRect(x: x,
                                                      y: y,
                                                      width: width,
                                                      height: height))
            imageView.image = image
            self.view.addSubview(imageView)
        }
    }
}

extension ButtonViewController: UINavigationControllerDelegate {
    
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
}
