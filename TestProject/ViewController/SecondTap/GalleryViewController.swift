//
//  GalleryViewController.swift
//  TestProject
//
//  Created by Silchenko on 03.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import Photos

class GalleryViewController: BaseViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    private var imagePicker = UIImagePickerController()
    private let spacing: CGFloat = 25
    private var photo = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView.collectionViewLayout as? ImageCollectionViewLayout {
            layout.delegate = self
        }
        self.navigationController?.delegate = self
        imagePicker.delegate = self
        registerCell()
        createBackButton()
        createRightButtons()
    }
    
    private func createRightButtons() {
        let camera = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonTapped))
        let gallery = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(galleryButtonTapped))
        self.navigationItem.rightBarButtonItems = [camera, gallery]
    }
    
    @objc func cameraButtonTapped() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func galleryButtonTapped() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
}

extension GalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func registerCell() {
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
        cell.configure(model: configureCell(index: indexPath.row))
        return cell
    }
    
    private func configureCell(index: Int) -> ImageCellViewModel {
        return ImageCellViewModel(borderWidth: 0,
                                  borderColor: UIColor.red.cgColor,
                                        image: photo[index])
    }
}

extension GalleryViewController: ImageCollectionViewLayoutDelegate {
    
    func heightFor(index: Int) -> CGFloat {
        let width = Int((collectionView.frame.width - spacing*3)/2)
        let scale = photo[index].preferredPresentationSizeForItemProvider.width / CGFloat(width)
        let height = photo[index].preferredPresentationSizeForItemProvider.height / scale
        return CGFloat(height)
    }
}

extension GalleryViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let image = image {
            photo.append(image)
            collectionView.reloadData()
        }
    }
}
