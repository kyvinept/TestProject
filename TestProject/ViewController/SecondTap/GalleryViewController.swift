//
//  GalleryViewController.swift
//  TestProject
//
//  Created by Silchenko on 03.10.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit
import Photos

protocol GalleryViewControllerDelegate: class {
    func backButtonTapped()
}

class GalleryViewController: UICollectionViewController {

    var delegate: GalleryViewControllerDelegate?
    private var imagePicker = UIImagePickerController()
    private let spacing: CGFloat = 25
    private var photo = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = collectionView?.collectionViewLayout as? ImageCollectionViewLayout {
            layout.delegate = self
        }
        self.navigationController?.delegate = self
        imagePicker.delegate = self
        registerCell()
        createBackButton()
        createCameraButton()
        getAllImages()
    }
    
    private func createBackButton() {
        let button = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = button
    }
    
    private func createCameraButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraButtonTapped))
        self.navigationItem.rightBarButtonItem = button
    }
    
    @objc func cameraButtonTapped() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
        delegate?.backButtonTapped()
    }
    
    private func getAllImages() {
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: PHFetchOptions())
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
                assets.enumerateObjects { object, index, stop in
                    self.convertToUIImage(image: object)
                    if index == fetchResult.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    private func convertToUIImage(image: PHAsset) {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        option.isSynchronous = true
        manager.requestImage(for: image,
                      targetSize: CGSize(width: 250, height: 250),
                     contentMode: .aspectFit,
                         options: option,
                   resultHandler: { (result, info) -> () in
                       if let result = result {
                            self.photo.append(result)
                       }
                   })
    }
}

extension GalleryViewController {
    
    private func registerCell() {
        collectionView!.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photo.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
        cell.configure(model: configureCell(index: indexPath.row))
        return cell
    }
    
    private func configureCell(index: Int) -> ImageCellViewModel {
        return ImageCellViewModel(borderWidth: 2,
                                  borderColor: UIColor.red.cgColor,
                                        image: photo[index])
    }
}

extension GalleryViewController: ImageCollectionViewLayoutDelegate {
    
    func heightFor(index: Int) -> CGFloat {
        let width = Int((collectionView!.frame.width - spacing*3)/2)
        let scale = photo[index].preferredPresentationSizeForItemProvider.width / CGFloat(width)
        let height = photo[index].preferredPresentationSizeForItemProvider.height / scale
        return CGFloat(height)
    }
}

extension GalleryViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}

extension GalleryViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let image = image {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            photo.append(image)
            collectionView?.reloadData()
        }
    }
}
