//
//  TableCell.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol CustomCellDelegate: class {
    func deleteButtonTapped(view: CustomCell)
}

class CustomCell: UITableViewCell {

    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    weak var delegate:CustomCellDelegate?
    private var isDeleteButtonShow = false
    private var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        createButton()
        createGegsture()
    }
    
    private func createButton() {
        deleteButton = UIButton(frame: CGRect(x: self.frame.width, y: 0, width: 100, height: self.frame.height))
        deleteButton!.backgroundColor = .red
        deleteButton!.setTitle("Delete", for: .normal)
        deleteButton!.isUserInteractionEnabled = false
        self.addSubview(deleteButton!)
    }
    
    private func createGegsture() {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeToDeleteCell(_:)))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeHideButton(_:)))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapToButton(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapToButton(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: deleteButton)
        if point.x > 0 && point.y > 0 && point.y < self.frame.height {
            hideButton()
            delegate?.deleteButtonTapped(view: self)
        }
    }
    
    @objc func swipeHideButton(_ gesture: UISwipeGestureRecognizer) {
        hideButton()
    }
    
    private func hideButton() {
        if isDeleteButtonShow == false {
            return
        }
        isDeleteButtonShow = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.frame.origin.x += 100
            self.deleteButton.frame.origin.x += 50
        }) { (_) in
            self.frame.size.width -= 200
        }
    }
    
    private func showButton() {
        if isDeleteButtonShow == true {
            return
        }
        isDeleteButtonShow = true
        
        self.frame.size.width += 200
        UIView.animate(withDuration: 0.5) {
            self.frame.origin.x -= 100
            self.deleteButton.frame.origin.x -= 50
        }
    }
    
    @objc func swipeToDeleteCell(_ gesture: UISwipeGestureRecognizer) {
        showButton()
    }
    
    func configure(model: CustomCellViewModel) {
        if model.image == nil {
            imgView.image = UIImage(named: "image")
            imgView.downloadImage(imageUrl: model.imageUrl)
        } else {
            imgView.image = model.image
        }
        
        idLabel.text = model.id
        idLabel.textColor = model.idColor
        
        titleLabel.text = model.title
        titleLabel.textColor = model.titleColor
        
        descriptionLabel.text = model.description
        descriptionLabel.textColor = model.descriptionColor
    }
}

extension UIImageView {
    
    func downloadImage(imageUrl: String) {
        NetworkingManager.shared.downloadImage(url: imageUrl) { (image) in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
