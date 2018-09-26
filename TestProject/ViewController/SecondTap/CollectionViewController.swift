//
//  CollectionViewController.swift
//  TestProject
//
//  Created by Silchenko on 24.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol CollectionViewControllerDelegate: class {
    func backButtonTapped()
}

class CollectionViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    weak var delegate: CollectionViewControllerDelegate?
    private let spacing: CGFloat = 25
    private var images = [UIImage]()
    private var imagesUrl = ["https://images-assets.nasa.gov/image/PIA18033/PIA18033~thumb.jpg",
                          "https://www.gettyimages.in/landing/assets/static_content/home/info-tabs3.jpg",
                          "https://www.gettyimages.ie/gi-resources/images/Homepage/Hero/UK/CMS_Creative_453010393_NeonShapes.jpg",
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAqIftOdn-YQ--soQAab_JqgM_v5Q09LbX6JAqjhDEbShw5f7C-A",
                          "https://cdn0.tnwcdn.com/wp-content/blogs.dir/1/files/2017/12/Screen-Shot-2017-12-04-at-10.39.57-796x447.png",
                          "https://www.w3schools.com/w3images/fjords.jpg",
                          "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCnujqDQMhwt0r1vpbGvRfKN2Ne13OK7eu1oIE31BIUR7k_peT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createStatusBar()
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        if let layout = collectionView?.collectionViewLayout as? ImageCollectionViewLayout {
            layout.delegate = self
        }
        createImageCells()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        switch UIDevice.current.orientation {
        case .portrait:
            deleteStatusBar()
            createStatusBar()
        case .landscapeLeft, .landscapeRight:
            deleteStatusBar()
            createStatusBar()
        default:
            break
        }
    }
    
    private func createImageCells() {
        for i in 0..<imagesUrl.count {
            downloadNewImage(imageUrl: imagesUrl[i])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.backButtonTapped()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Input image url", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Image url..."
        }
        alert.addAction(UIAlertAction(title: "Input", style: .default, handler: { (_) in
            let url = alert.textFields![0].text!
            if url == "" {
                self.showErrorMessage(message: "Empty id field. Try again!")
                return
            }
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func downloadNewImage(imageUrl: String) {
        NetworkingManager.shared.downloadImage(url: imageUrl, saveImage: { (image) in
            DispatchQueue.main.async {
                self.images.append(image)
                self.collectionView.reloadData()
                self.collectionView.collectionViewLayout.prepare()
            }
        })
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ImageCell
        cell?.configure(model: ImageCellViewModel(borderWidth: 3,
                                                  borderColor: UIColor.white.cgColor,
                                                        image: images[indexPath.row]))
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        imageVC.transitioningDelegate = self
        self.present(imageVC, animated: true, completion: nil)
        imageVC.configure(image: images[indexPath.row])
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = Int((self.view.frame.width - spacing*3)/2)
//        let scale = images[indexPath.row].preferredPresentationSizeForItemProvider.width / CGFloat(width)
//        print(scale)
//        let height = images[indexPath.row].preferredPresentationSizeForItemProvider.height / scale
//        print(height)
//        return CGSize(width: CGFloat(width), height: height)
//    }
}

extension CollectionViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}

extension CollectionViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentRotateAnimation()
    }
}

extension CollectionViewController: ImageCollectionViewLayoutDelegate {
    
    func heightFor(index: Int) -> CGFloat {
        let width = Int((self.view.frame.width - spacing*3)/2)
        let scale = images[index].preferredPresentationSizeForItemProvider.width / CGFloat(width)
        let height = images[index].preferredPresentationSizeForItemProvider.height / scale
        return CGFloat(height)
    }
}
