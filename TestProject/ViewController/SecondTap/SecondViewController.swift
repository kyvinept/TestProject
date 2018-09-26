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
        case "TableCell":
            let textVC = self.storyboard?.instantiateViewController(withIdentifier: "TableViewController") as? TableViewController
            if let textVC = textVC {
                textVC.delegate = self
                self.navigationController?.pushViewController(textVC, animated: true)
            }
        case "CollectionCell":
            let textVC = self.storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController
            if let textVC = textVC {
                textVC.delegate = self
                self.navigationController?.pushViewController(textVC, animated: true)
            }
        case "CollectionsCell":
            let textVC = self.storyboard?.instantiateViewController(withIdentifier: "ScrollCollectionViewController") as? ScrollCollectionViewController
            if let textVC = textVC {
                textVC.delegate = self
                self.navigationController?.pushViewController(textVC, animated: true)
            }
        case "StackCell":
            let textVC = self.storyboard?.instantiateViewController(withIdentifier: "StackViewController") as? StackViewController
            if let textVC = textVC {
                textVC.delegate = self
                self.navigationController?.pushViewController(textVC, animated: true)
            }
        default:
            break
        }
    }
}

extension SecondViewController: PresentingViewControllerDelegate, TableViewControllerDelegate, CollectionViewControllerDelegate, ScrollCollectionViewControllerDelegate, StackViewControllerDelegate {
    
    func backButtonTapped() {
        self.navigationController?.delegate = self
    }
}

extension SecondViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return AnimationFromRightCorner()
        default:
            return nil
        }
    }
}

