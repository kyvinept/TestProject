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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNavigationControllers() {
        let first = UINavigationController(rootViewController: FirstViewController(nibName: "FirstViewController", bundle: nil))
        first.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        let second = UINavigationController(rootViewController: SecondViewController())
        second.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)

        let third = UINavigationController(rootViewController: ThirdViewController())
        third.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)

        let fourth = UINavigationController(rootViewController: FourthViewController())
        fourth.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 3)
        
        let tabBarList = [first, second, third, fourth]
        self.viewControllers = tabBarList
    }
}
