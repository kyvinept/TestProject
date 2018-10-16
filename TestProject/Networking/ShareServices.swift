//
//  ShareManager.swift
//  TestProject
//
//  Created by Silchenko on 12.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import FacebookShare
import MessageUI

class ShareServices {
    
    static let share = ShareServices()
    
    private init() { }
    
    func shareFacebook(image: UIImage, from viewController: UIViewController) {
        let photo = Photo(image: image, userGenerated: true)
        let content = PhotoShareContent(photos: [photo])
        do {
            try ShareDialog.show(from: viewController, content: content)
        } catch {
            print("Error")
        }
    }
    
    func shareGmail(viewController: UIViewController, image: UIImage) {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = viewController as! MFMailComposeViewControllerDelegate
        composeVC.setToRecipients(["kyvinept@gmail.com"])
        composeVC.setSubject("Image")
        composeVC.setMessageBody("", isHTML: false)
        composeVC.addAttachmentData(UIImageJPEGRepresentation(image, CGFloat(1.0))!, mimeType: "image/jpeg", fileName:  "test.jpeg")
        viewController.present(composeVC, animated: true, completion: nil)
    }
}
