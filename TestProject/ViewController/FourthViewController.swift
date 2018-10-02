//
//  FourthViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FourthViewController: UIViewController {

    let urlString = "https://jsonplaceholder.typicode.com/posts"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("FourthViewController", comment: "")
        self.navigationController?.delegate = self
        //createPostRequest()
        //createDeleteRequest()
        createGetRequest()
        //createPutRequest()
        //createPatchRequest()
    }
    
    func createPatchRequest() {
        Alamofire.request(urlString+"/1", method: .patch, parameters: ["title":"foo", "body": "12345"]).responseJSON { (responce) in
            print(responce)
        }
    }
    
    func createDeleteRequest() {
        Alamofire.request(urlString+"/1", method: .delete).responseJSON { (responce) in
            print(responce)
        }
    }
    
    func createPutRequest() {
        Alamofire.request(urlString+"/1", method: .put, parameters: ["title": "foo", "body": "bar", "userId": 1])
        .responseJSON { (responce) in
            print(responce)
        }
    }
    
    func createGetRequest() {
        Alamofire.request(urlString + "/1").responseData { (responce) in
            switch responce.result {
            case .success(let data):
                let json = JSON(data)
                print(json)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createPostRequest() {
        Alamofire.request(urlString, method: .post, parameters: ["title": "foo", "body": "bar", "userId": 1])
            .responseJSON { response in
            switch response.result {
            case .success:
                print(response)
                break
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension FourthViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return AnimationFromRightCorner()
        default:
            return nil
        }
    }
}

extension FourthViewController: NewViewControllerDelegate {
    
    func backButtonTapped() {
        self.navigationController?.delegate = self
    }
}

