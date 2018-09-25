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
        createImageCells()
        collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionViewHorizontal.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }
    
    private func sizeForHorizontalCollectionView() {
        let height = self.view.frame.height / 3
        if height > 200 {
            collectionViewHorizontal.frame.size.height = height
        } else {
            collectionViewHorizontal.frame.size.height = 200
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionViewHorizontal.frame.size.width = scrollView.frame.width
        collectionView.frame.size.width = scrollView.frame.width
        collectionView.frame.origin.y = collectionViewHorizontal.frame.origin.y + collectionViewHorizontal.frame.height
        collectionView.reloadData()
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
    
    private func downloadNewImage(imageUrl: String) {
        NetworkingManager.shared.downloadImage(url: imageUrl, saveImage: { (image) in
            DispatchQueue.main.async {
                self.images.append(image)
                self.collectionView.reloadData()
                self.collectionViewHorizontal.reloadData()
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
        calculateSize(count: images.count)
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ImageCell
        cell?.configure(model: ImageCellViewModel(borderWidth: 3,
                                                  borderColor: UIColor.blue.cgColor,
                                                        image: images[indexPath.row]))
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewHorizontal {
            let height = collectionViewHorizontal.frame.height - spacing*2
            return CGSize(width: height, height: height)
        } else {
            let width = CGFloat(Int((scrollView.frame.width - spacing*3)/2))
            return CGSize(width: width, height: width)
        }
    }
    
    private func calculateSize(count: Int) {
        let width = ((scrollView.frame.width - spacing*3)/2)
        var k = count
        if k % 2 == 1 {
            k+=1
        }
        collectionView.frame.size.height = CGFloat(k/2)*width + spacing*CGFloat((k/2+1))
        scrollView.contentSize.height = collectionViewHorizontal.frame.height + collectionView.frame.height
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
