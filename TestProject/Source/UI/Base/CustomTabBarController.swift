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
        DeeplinkManager.share.delegate = self
        createNavigationControllers()
    }
    
    private func createNavigationControllers() {
        let first = createNewController(viewController: UIStoryboard(name: "FirstTap", bundle: nil).instantiateViewController(withIdentifier: "FirstViewController"),
                                                 title: NSLocalizedString("FirstViewController", comment: ""),
                                                 image: #imageLiteral(resourceName: "star"),
                                         selectedImage: nil)
        let second = createNewController(viewController: UIStoryboard(name: "SecondTap", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController"),
                                                  title: NSLocalizedString("SecondViewController", comment: ""),
                                                  image: #imageLiteral(resourceName: "medical-history"),
                                          selectedImage: nil)
        let third = createNewController(viewController: UIStoryboard(name: "ThirdTap", bundle: nil).instantiateViewController(withIdentifier: "ThirdViewController"),
                                                 title: NSLocalizedString("ThirdViewController", comment: ""),
                                                 image: #imageLiteral(resourceName: "download"),
                                         selectedImage: nil)
        let fourth = createNewController(viewController: UIStoryboard(name: "FourthViewController", bundle: nil).instantiateViewController(withIdentifier: "FourthViewController"),
                                                  title: NSLocalizedString("FourthViewController", comment: ""),
                                                  image: #imageLiteral(resourceName: "round-add-button"),
                                          selectedImage: nil)
        
        let tabBarList = [first, second, third, fourth]
        self.viewControllers = tabBarList
        self.tabBar.tintColor = UIColor.purple
    }
    
    private func createNewController(viewController: UIViewController, title: String?, image: UIImage?, selectedImage: UIImage?) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: title,
                                                       image: image,
                                               selectedImage: selectedImage)
        return navigationController
    }
}

extension CustomTabBarController: DeeplinkManagerDelegate {
    
    func getNewViewController(withIdentifire: String) {
        switch withIdentifire {
        case DeeplinkPath.secondViewController.rawValue:
            self.selectedIndex = 1
        case DeeplinkPath.thirdViewController.rawValue:
            self.selectedIndex = 2
        case DeeplinkPath.testApiController.rawValue:
            let testApiController = UIStoryboard(name: "ThirdTap", bundle: nil).instantiateViewController(withIdentifier: DeeplinkPath.testApiController.rawValue)
            (self.selectedViewController as? UINavigationController)?.pushViewController(testApiController, animated: false)
        default:
            break
        }
    }
}

extension CustomTabBarController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let selectedVC = selectedViewController{
                return selectedVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let selectedVC = selectedViewController{
                return selectedVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let selectedVC = selectedViewController{
                return selectedVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }
}

extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let selectedVC = visibleViewController {
                return selectedVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let selectedVC = visibleViewController {
                return selectedVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let selectedVC = visibleViewController {
                return selectedVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }
}
