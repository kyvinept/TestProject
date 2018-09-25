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
    
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: CollectionViewControllerDelegate?
    private let spacing: CGFloat = 25
    private var images = ["https://images-assets.nasa.gov/image/PIA18033/PIA18033~thumb.jpg",
                          "https://www.gettyimages.in/landing/assets/static_content/home/info-tabs3.jpg",
                          "https://www.gettyimages.ie/gi-resources/images/Homepage/Hero/UK/CMS_Creative_453010393_NeonShapes.jpg",
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAqIftOdn-YQ--soQAab_JqgM_v5Q09LbX6JAqjhDEbShw5f7C-A",
                          "https://cdn0.tnwcdn.com/wp-content/blogs.dir/1/files/2017/12/Screen-Shot-2017-12-04-at-10.39.57-796x447.png",
                          "https://images-assets.nasa.gov/image/PIA18033/PIA18033~thumb.jpg",
                          "https://www.gettyimages.in/landing/assets/static_content/home/info-tabs3.jpg",
                          "https://www.gettyimages.ie/gi-resources/images/Homepage/Hero/UK/CMS_Creative_453010393_NeonShapes.jpg",
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAqIftOdn-YQ--soQAab_JqgM_v5Q09LbX6JAqjhDEbShw5f7C-A",
                          "https://cdn0.tnwcdn.com/wp-content/blogs.dir/1/files/2017/12/Screen-Shot-2017-12-04-at-10.39.57-796x447.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        createStatusBar()
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
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
            self.images.append(url)
            self.collectionView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ImageCell
        cell?.configure(model: ImageCellViewModel(borderWidth: 3,
                                                  borderColor: UIColor.white.cgColor,
                                                     imageUrl: images[indexPath.row]))
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        imageVC.transitioningDelegate = self
        self.present(imageVC, animated: true, completion: nil)
        imageVC.configure(url: images[indexPath.row])
    }
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

