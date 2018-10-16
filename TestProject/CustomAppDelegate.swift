//
//  CustomAppDelegate.swift
//  TestProject
//
//  Created by Silchenko on 17.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
// f0d6631447ae22b4bc2ec0d278c2ff6361a9a382e3ffc28a9c5ebec3e5e0b3ef

import UIKit
import UserNotifications
import FacebookShare
import FacebookLogin
import FacebookCore
import GoogleSignIn
import TwitterKit

@UIApplicationMain
class CustomAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var shouldRotate = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CustomTabBarController()
        window?.makeKeyAndVisible()
        
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        TWTRTwitter.sharedInstance().start(withConsumerKey:"hTpkPVU4pThkM0", consumerSecret:"ovEqziMzLpUOF163Qg2mj")
        NotificationManager.share.checkNotification(window: window!, launchOptions: launchOptions)
        
        return true
    }
}
