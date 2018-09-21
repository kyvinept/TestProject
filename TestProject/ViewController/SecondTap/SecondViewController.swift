//
//  SecondViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class SecondViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SecondViewController"
        self.navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier
        switch identifier {
        case "PresentingCell":
            let textVC = self.storyboard?.instantiateViewController(withIdentifier: "PresentingViewController") as? PresentingViewController
            if let textVC = textVC {
                textVC.delegate = self
                self.navigationController?.pushViewController(textVC, animated: true)
            }
        default:
            break
        }
    }
}

extension SecondViewController: PresentingViewControllerDelegate {
    
    func backButtonTapped() {
        self.navigationController?.delegate = self
    }
}

extension SecondViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return CustomPushAnimator()
        default:
            return nil
        }
    }
}

