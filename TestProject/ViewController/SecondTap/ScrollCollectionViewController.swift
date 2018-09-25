//
//  ScrollCollectionViewController.swift
//  TestProject
//
//  Created by Silchenko on 25.09.2018.
//  Copyright © 2018 Silchenko. All rights reserved.
//

import UIKit

protocol ScrollCollectionViewControllerDelegate: class {
    func backButtonTapped()
}

class ScrollCollectionViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHorizontal: UICollectionView!
    weak var delegate: ScrollCollectionViewControllerDelegate?
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
        createImageCells()
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionViewHorizontal.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
    
    private func createImageCells() {
        for i in 0..<imagesUrl.count {
            downloadNewImage(imageUrl: imagesUrl[i])
        }
    }
    
    private func downloadNewImage(imageUrl: String) {
        NetworkingManager.shared.downloadImage(url: imageUrl, saveImage: { (image) in
            DispatchQueue.main.async {
                self.images.append(image)
                self.collectionView.reloadData()
                self.collectionViewHorizontal.reloadData()
                self.collectionView.frame.size.height = self.collectionView.contentSize.height
                self.scrollView.contentSize.height = self.collectionViewHorizontal.frame.height + self.collectionView.frame.height 
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        delegate?.backButtonTapped()
    }
}

extension ScrollCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ImageCell
        cell?.configure(model: ImageCellViewModel(borderWidth: 3,
                                                  borderColor: UIColor.blue.cgColor,
                                                        image: images[indexPath.row]))
        return cell!
    }
}

extension ScrollCollectionViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            return CustomPopAnimator()
        default:
            return nil
        }
    }
}
