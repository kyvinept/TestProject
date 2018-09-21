//
//  ViewController.swift
//  TestProject
//
//  Created by Silchenko on 13.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol TextViewControllerDelegate: class {
    func backButtonTapped()
}

class TextViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    private let leftConstraintConstant: CGFloat = 10
    private let rightConstraintConstant: CGFloat = 10
    private let topConstraintConstant: CGFloat = 10
    weak var delegate: TextViewControllerDelegate?
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        addGesture()
        addNotification()
        createElements()
        createStatusBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewSizeSet(scrollView: scrollView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollViewSizeSet(scrollView: scrollView)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            bottomConstraint.constant = keyboardSize.height
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
    }
    
    private func addGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToView(_ :)))
        self.view.addGestureRecognizer(tap)
    }
    
    private func addNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                                   name: .UIKeyboardWillShow,
                                                 object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                                   name: .UIKeyboardWillHide,
                                                 object: nil)
    }
    
    @objc private func tapToView(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.backButtonTapped()
    }
}

extension TextViewController {
    
    private func createElements() {
        var createView: UIView = scrollView
        for i in 1...40 {
            let randomWidth = Int(arc4random_uniform(UInt32(UIScreen.main.bounds.width - 80 - leftConstraintConstant - rightConstraintConstant)) + 80)
            switch Int(arc4random_uniform(3)) {
            case 0:
                createView = createLabel(widthSize: CGFloat(randomWidth),
                                            toItem: createView,
                                              item: i)
            case 1:
                createView = createTextField(widthSize: CGFloat(randomWidth),
                                                toItem: createView,
                                                  item: i)
            case 2:
                createView = createTextView(widthSize: CGFloat(randomWidth),
                                               toItem: createView,
                                                 item: i)
            default:
                break
            }
        }
    }
    
    private func createLabel(widthSize: CGFloat, toItem: UIView, item: Int) -> UILabel {
        let label = UILabel()
        let str = "Label number " + String(item)
        let attributedString = NSMutableAttributedString(string: str)
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                      value: UIColor.randomColor(),
                                      range: NSMakeRange(4, 8))
        attributedString.addAttribute(NSAttributedStringKey.foregroundColor,
                                      value: UIColor.randomColor(),
                                      range: NSMakeRange(0, 5))
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(label)
        let constraints = setConstraints(object: label,
                                       toObject: toItem,
                                      widthSize: widthSize,
                                   toLeftObject: scrollView,
                                   leftConstant: leftConstraintConstant,
                                    topConstant: topConstraintConstant)
        scrollView.addConstraints(constraints)
        return label
    }
    
    private func createTextField(widthSize: CGFloat, toItem: UIView, item: Int) -> UITextField {
        let textField = UITextField()
        textField.text = "TextField number " + String(item)
        textField.backgroundColor = UIColor.randomColor()
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.keyboardType = randomKeyboardType()
        scrollView.addSubview(textField)
        let constraints = setConstraints(object: textField,
                                       toObject: toItem,
                                      widthSize: widthSize,
                                   toLeftObject: scrollView,
                                   leftConstant: leftConstraintConstant,
                                    topConstant: topConstraintConstant)
        scrollView.addConstraints(constraints)
        return textField
    }
    
    private func randomKeyboardType() -> UIKeyboardType {
        var type: UIKeyboardType = .default
        let random = arc4random_uniform(3)
        switch random {
        case 1:
            type = .numberPad
        case 2:
            type = .numbersAndPunctuation
        default:
            break
        }
        return type
    }
    
    private func createTextView(widthSize: CGFloat, toItem: UIView, item: Int) -> UITextView {
        let textView = UITextView()
        textView.text = "TextView number " + String(item)
        textView.textColor = UIColor.randomColor()
        textView.isScrollEnabled = false
        textView.keyboardType = randomKeyboardType()
        textView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(textView)
        let constraints = setConstraints(object: textView,
                                       toObject: toItem,
                                      widthSize: widthSize,
                                   toLeftObject: scrollView,
                                   leftConstant: leftConstraintConstant,
                                    topConstant: topConstraintConstant)
        scrollView.addConstraints(constraints)
        return textView
    }
}

extension TextViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}

extension TextViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension UIColor {
    
    static func randomColor() -> UIColor {
        return UIColor(red: .random(),
                     green: .random(),
                      blue: .random(),
                     alpha: 1.0)
    }
}

extension CGFloat {
    
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
