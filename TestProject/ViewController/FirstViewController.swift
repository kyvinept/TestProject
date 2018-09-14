//
//  ViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.title = "FirstViewController"
        createElements()
        addGesture()
    }
    
    func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToView(_ :)))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func tapToView(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func openNewViewController(_ sender: Any) {
        let newVC = NewViewController(nibName: "NewView", bundle: nil)
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension FirstViewController {
    func createElements() {
        var y = 5
        for i in 1...15 {
            let randomWidth = Int(arc4random_uniform(UInt32(view.frame.width-80))+80)
            let randomHeight = Int(arc4random_uniform(250)+50)
            switch Int(arc4random_uniform(3)) {
            case 0:
                createLabel(frame: CGRect(x: 10, y: y, width: randomWidth, height: 60), item: i)
                y += 70
            case 1:
                createTextField(frame: CGRect(x: 10, y: y, width: randomWidth, height: 60), item: i)
                y += 70
            case 2:
                createTextView(frame: CGRect(x: 10, y: y, width: randomWidth, height: randomHeight), item: i)
                y += randomHeight + 10
            default:
                break
            }
        }
        scrollView.contentSize.height = CGFloat(y)
    }
    
    func createLabel(frame: CGRect, item: Int){
        let label = UILabel(frame: frame)
        label.text = "Label number " + String(item)
        label.textColor = UIColor.randomColor()
        scrollView.addSubview(label)
    }
    
    func createTextField(frame: CGRect, item: Int) {
        let textField = UITextField(frame: frame)
        textField.text = "TextField number " + String(item)
        textField.backgroundColor = UIColor.randomColor()
        scrollView.addSubview(textField)
    }
    
    func createTextView(frame: CGRect, item: Int) {
        let textView = UITextView(frame: frame)
        textView.text = "TextView number " + String(item)
        textView.textColor = UIColor.randomColor()
        scrollView.addSubview(textView)
    }
}

extension FirstViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return CustomAnimator(direction: .Bottom)
        default:
            return nil
        }
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
