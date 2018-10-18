//
//  DeeplinkManager.swift
//  TestProject
//
//  Created by Silchenko on 16.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import Branch

enum DeeplinkPath {
    case ThirdViewController
    case SecondViewController
}

class DeeplinkManager {
    
    static let share = DeeplinkManager()
    
    private init() { }
    
    func initSession(window: UIWindow, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            guard let data = params as? [String: AnyObject] else { return }
            
            let to = data["to"]
            if let to = to as? String {
                self.openViewController(window: window, to: to)
            }
        }
    }
    
    private func openViewController(window: UIWindow, to: String) {
        switch to {
        case "SecondViewController":
            (window.rootViewController as? UITabBarController)?.selectedIndex = 1
        case "ThirdViewController":
            (window.rootViewController as? UITabBarController)?.selectedIndex = 2
        default:
            break;
        }
    }
    
    func countinueSession(userActivity: NSUserActivity) {
        Branch.getInstance().continue(userActivity)
    }
}
