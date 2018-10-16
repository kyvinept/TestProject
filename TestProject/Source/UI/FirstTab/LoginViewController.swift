//
//  LoginViewController.swift
//  TestProject
//
//  Created by Silchenko on 11.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit

class LoginViewController: BaseViewController {
    
    private var dict : [String : AnyObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createBackButton()
        
    }
    @IBAction func googleLoginButtonTapped(_ sender: Any) {
        LoginServices.shared.logInFromGoogle()
    }
    
    @IBAction func facebookLoginButtonTapped(_ sender: Any) {
        LoginServices.shared.logInFromFacebook()
    }
    
    @IBAction func twitterLoginButtonTapped(_ sender: Any) {

    }
}

