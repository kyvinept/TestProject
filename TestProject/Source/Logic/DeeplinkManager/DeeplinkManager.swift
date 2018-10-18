//
//  DeeplinkManager.swift
//  TestProject
//
//  Created by Silchenko on 16.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import Branch

protocol DeeplinkManagerDelegate: class {
    func getNewViewController(withIdentifire: String)
}

enum DeeplinkPath : String {
    case thirdViewController = "ThirdViewController"
    case secondViewController = "SecondViewController"
    case testApiController = "TestApiController"
}

class DeeplinkManager {
    
    static let share = DeeplinkManager()
    var delegate: DeeplinkManagerDelegate?
    
    private init() { }
    
    func initSession(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            guard let data = params as? [String: AnyObject] else { return }
            
            let to = data["to"]
            if let to = to as? String {
                self.delegate?.getNewViewController(withIdentifire: to)
            }
        }
    }

    func countinueSession(userActivity: NSUserActivity) {
        Branch.getInstance().continue(userActivity)
    }
}
