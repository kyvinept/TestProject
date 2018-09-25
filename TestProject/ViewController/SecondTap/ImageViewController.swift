//
//  ImageViewController.swift
//  TestProject
//
//  Created by Silchenko on 24.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    private var imageView: UIImageView!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewImageView()
        createStatusBar()
    }
   
    private func createNewImageView() {
        imageView = BigImageShowView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        self.view.addSubview(navigationBar)
    }
    
    private func changeSizeImageView(image: UIImage) {
        let width = image.size.width
        let scale = width / self.view.frame.width
        let height = image.size.height / scale
        imageView.frame.size.height = height
        imageView.center = self.view.center
    }
    
    func configure(image: UIImage) {
        imageView.image = image
        changeSizeImageView(image: image)
    }
    
    func configure(url: String) {
        imageView.downloadImage(imageUrl: url)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        guard let image = imageView.image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
}
