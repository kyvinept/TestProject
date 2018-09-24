//
//  TableCell.swift
//  TestProject
//
//  Created by Silchenko on 21.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol CustomCellDelegate: class {
    func swipeCellToDelete(viewModelCell: CustomCellViewModel)
}

class CustomCell: UITableViewCell {

    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    weak var delegate:CustomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(deleteCell(_:)))
        swipe.direction = .left
        self.addGestureRecognizer(swipe)
    }
    
    @objc func deleteCell(_ gesture: UISwipeGestureRecognizer) {
        delegate?.swipeCellToDelete(viewModelCell: getProperties())
    }
    
    func setProperties(model: CustomCellViewModel) {
        imgView.image = model.image
        
        idLabel.text = model.id
        idLabel.textColor = model.idColor
        
        titleLabel.text = model.title
        titleLabel.textColor = model.titleColor
        
        descriptionLabel.text = model.description
        descriptionLabel.textColor = model.descriptionColor
    }
    
    func getProperties() -> CustomCellViewModel {
        return CustomCellViewModel(id: idLabel.text!,
                              idColor: idLabel.textColor,
                                title: titleLabel.text!,
                           titleColor: titleLabel.textColor,
                          description: descriptionLabel.text!,
                     descriptionColor: descriptionLabel.textColor,
                                image: imageView!.image)
    }
}
