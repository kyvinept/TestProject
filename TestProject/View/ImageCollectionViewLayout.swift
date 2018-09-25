//
//  ImageCollectionViewLayout.swift
//  TestProject
//
//  Created by Silchenko on 25.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol ImageCollectionViewLayoutDelegate: class {
    func heightFor(index : Int) -> CGFloat
}

class ImageCollectionViewLayout: UICollectionViewLayout {
    
    var delegate : ImageCollectionViewLayoutDelegate?
    private var leftY: CGFloat = 0
    private var rightY: CGFloat = 0
    private let margin: CGFloat = 25
    private let verticalSpacing: CGFloat = 25
    private let horizontalSpacing: CGFloat = 25
    private var cache = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        guard let collectionView = collectionView else {//cache.isEmpty == true,
            return
        }
        leftY = margin
        rightY = margin
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            var frame = CGRect.zero
            let cellHeight = self.delegate!.heightFor(index: item)
            frame.size.height = cellHeight
            frame.size.width = (collectionView.frame.size.width - 2 * margin) / 2 - horizontalSpacing/2
            if item % 2 == 0 {
                frame.origin.x = margin
                frame.origin.y = leftY
                leftY += cellHeight + verticalSpacing
            } else {
                frame.origin.x = (collectionView.frame.size.width - 2 * margin) / 2 +  ((4 * horizontalSpacing) / 3)
                frame.origin.y = rightY
                rightY += cellHeight + verticalSpacing
            }
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = frame
            cache.append(attributes)
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override var collectionViewContentSize: CGSize{
        return CGSize.init(width: collectionView!.frame.size.width, height: max(leftY, rightY))
    }
}
