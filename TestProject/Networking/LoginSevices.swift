//
//  LoginManager.swift
//  TestProject
//
//  Created by Silchenko on 11.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import GoogleSignIn

class LoginSevices: NSObject {
    
    static let shared = LoginSevices()
    
    private override init() {
        super.init()
        GIDSignIn.sharedInstance().clientID = "518882178024-mp7kqn3vdmcooep77p26f366s04faah5.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
}

extension LoginSevices {
    
    func logInFromFacebook() {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile ], viewController: LoginViewController()) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(_, _, let token):
                self.getUserProfile(token: token)
            }
        }
    }

    private func getUserProfile(token: AccessToken) {
        let connection = GraphRequestConnection()
        connection.add(GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"], accessToken: token, httpMethod: GraphRequestHTTPMethod(rawValue: "GET")!, apiVersion: "2.8")) { httpResponse, result in
            switch result {
            case .success(let response):
                print("Graph Request Succeeded: \(response)")
                print("Custom Graph Request Succeeded: \(response)")
                print("My facebook id is \(response.dictionaryValue?["id"])")
                print("My name is \(response.dictionaryValue?["name"])")
            case .failed(let error):
                print("Graph Request Failed: \(error)")
            }
        }
        connection.start()
    }
}

extension LoginSevices: GIDSignInDelegate, GIDSignInUIDelegate {
    
    func logInFromGoogle() {
        GIDSignIn.sharedInstance().signIn()
    }
 
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            print(user.userID)
            print(user.authentication.idToken)
            print(user.profile.name)
            print(user.profile.givenName)
            print(user.profile.familyName)
            print(user.profile.email)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        print("Open")
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        print("Close")
    }
}




