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
        self.title = "FirstViewController"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let textVC = UIStoryboard(name: "FirstTap", bundle: nil).instantiateViewController(withIdentifier: "TextViewController")
            self.navigationController?.pushViewController(textVC, animated: true)
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none
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
