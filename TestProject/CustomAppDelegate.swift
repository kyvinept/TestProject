//
//  CustomAppDelegate.swift
//  TestProject
//
//  Created by Silchenko on 17.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

@UIApplicationMain
class CustomAppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var shouldRotate = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CustomTabBarController()
        window?.makeKeyAndVisible()
        return true
    }
}
