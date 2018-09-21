//
//  PresentingViewController.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol PresentingViewControllerDelegate: class {
    func backButtonTapped()
}

class PresentingViewController: UIViewController {
    
    weak var delegate: PresentingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createStatusBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.backButtonTapped()
    }
    
    @IBAction func coverVerticalButtonTapped(_ sender: Any) {
        openNewVC(transitionStyle: .coverVertical)
    }
    
    @IBAction func crossDissolveButtonTapped(_ sender: Any) {
        openNewVC(transitionStyle: .crossDissolve)
    }
    
    @IBAction func flipHorizontalButtonTapped(_ sender: Any) {
        openNewVC(transitionStyle: .flipHorizontal)
    }
    
    @IBAction func partialCurlButtonTapped(_ sender: Any) {
        openNewVC(transitionStyle: .partialCurl)
    }
    
    @IBAction func customButtonTapped(_ sender: Any) {
        let newVC = createNewVC()
        newVC.transitioningDelegate = self
        self.present(newVC, animated: true, completion: nil)
    }
    
    private func openNewVC(transitionStyle: UIModalTransitionStyle) {
        let newVC = createNewVC()
        newVC.modalTransitionStyle = transitionStyle
        self.present(newVC, animated: true, completion: nil)
    }
    
    private func createNewVC() -> UIViewController {
        return UIStoryboard(name: "NewViewController", bundle: nil).instantiateViewController(withIdentifier: "NewViewController")
    }
}

extension PresentingViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}

extension PresentingViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return PresentAnimation()
    }
}
