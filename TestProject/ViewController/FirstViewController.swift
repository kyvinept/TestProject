//
//  FirstViewController.swift
//  TestProject
//
//  Created by Silchenko on 17.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.title = "FirstViewController"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier
        switch identifier {
        case "TextCell":
            let textVC = self.storyboard?.instantiateViewController(withIdentifier: "TextViewController") as? TextViewController
            if let textVC = textVC {
                textVC.delegate = self
                self.navigationController?.pushViewController(textVC, animated: true)
            }
        case "UIObjectCell":
            let textVC = self.storyboard?.instantiateViewController(withIdentifier: "UIObjectViewController") as? UIObjectViewController
            if let textVC = textVC {
                textVC.delegate = self
                self.navigationController?.pushViewController(textVC, animated: true)
            }
        case "GestureCell":
            let textVC = self.storyboard?.instantiateViewController(withIdentifier: "GestureViewController") as? GestureViewController
            if let textVC = textVC {
                textVC.delegate = self
                self.navigationController?.pushViewController(textVC, animated: true)
            }
        case "DynamicsCell":
            let textVC = self.storyboard?.instantiateViewController(withIdentifier: "DynamicsViewController") as? DynamicsViewController
            if let textVC = textVC {
                textVC.delegate = self
                self.navigationController?.pushViewController(textVC, animated: true)
            }
        default:
            break
        }
    }
}

extension FirstViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return CustomPushAnimator()
        default:
            return nil
        }
    }
}

extension FirstViewController: TextViewControllerDelegate, UIObjectViewControllerDelegate, GestureViewControllerDelegate, DynamicsViewControllerDelegate {
    
    func backButtonTapped() {
        self.navigationController?.delegate = self
    }
}
