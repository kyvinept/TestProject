//
//  TabBarViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigationControllers()
    }
    
    private func createNavigationControllers() {
        let first = createNewController(viewController: FirstViewController(nibName: "FirstView", bundle: nil), title: "FirstViewController", image: #imageLiteral(resourceName: "star"), selectedImage: nil)
        let second = createNewController(viewController: SecondViewController(nibName: "SecondView", bundle: nil), title: "SecondViewController", image: #imageLiteral(resourceName: "medical-history"), selectedImage: nil)
        let third = createNewController(viewController: ThirdViewController(nibName: "ThirdView", bundle: nil), title: "ThirdViewController", image: #imageLiteral(resourceName: "download"), selectedImage: nil)
        let fourth = createNewController(viewController: FourthViewController(nibName: "FourthView", bundle: nil), title: "FourthViewController", image: #imageLiteral(resourceName: "round-add-button"), selectedImage: nil)
        
        let tabBarList = [first, second, third, fourth]
        self.viewControllers = tabBarList
        self.tabBar.tintColor = UIColor.purple
    }
    
    private func createNewController(viewController: UIViewController, title: String?, image: UIImage?, selectedImage: UIImage?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        return navigationController
    }
}
