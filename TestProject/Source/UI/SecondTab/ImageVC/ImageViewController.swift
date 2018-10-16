//
//  ImageViewController.swift
//  TestProject
//
//  Created by Silchenko on 24.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import MessageUI

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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = self.view.center
        changeSizeImageView(image: imageView.image!)
        deleteStatusBar()
        createStatusBar()
    }
    
    private func changeSizeImageView(image: UIImage) {
        if self.view.frame.width < self.view.frame.height {
            
            let width = image.size.width
            let scale = width / self.view.frame.width
            let height = image.size.height / scale
            imageView.frame.size.height = height
            imageView.frame.size.width = self.view.frame.width
            imageView.center = self.view.center
            
        } else {
            
            let height = image.size.height
            let scale = height / self.view.frame.height
            let width = image.size.width / scale
            imageView.frame.size.width = width
            imageView.frame.size.height = self.view.frame.height
            imageView.center = self.view.center
        }
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
    
    @IBAction func facebookShareButtonTapped(_ sender: Any) {
        ShareServices.share.shareFacebook(image: imageView.image!, from: self)
    }
    
    @IBAction func gmailShareButtonTapped(_ sender: Any) {
        ShareServices.share.shareGmail(viewController: self, image: imageView.image!)
    }
}

extension ImageViewController : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
