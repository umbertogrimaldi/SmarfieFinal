//
//  PreviewViewController.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 05/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var myPhotoCollectionView: UICollectionView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var mySessionCollectionView: UIImageView!

    var centerPoint: CGPoint = CGPoint(x: 200, y: 400)
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var insets = self.myPhotoCollectionView.contentInset
        let value = (self.view.frame.size.width - (self.myPhotoCollectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width) * 0.5
            insets.left = value
            insets.right = value
        self.myPhotoCollectionView.contentInset = insets
        self.myPhotoCollectionView.decelerationRate = UIScrollViewDecelerationRateNormal
        myPhotoCollectionView.backgroundColor = UIColor.white
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(PhotoShared.shared.myPhotoArray!.count)
        myPhotoCollectionView.delegate = self
        myPhotoCollectionView.dataSource = self
        navigationController?.delegate = self
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0)]
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }


    @IBAction func shareTapped(_ sender: Any) {
        var photoToShare: UIImage?
        let center = view.convert(self.myPhotoCollectionView.center, to: self.myPhotoCollectionView)
        if let index = myPhotoCollectionView!.indexPathForItem(at:center) {
            photoToShare = PhotoShared.shared.myPhotoArray![index.row]
        }
            
        let activityController = UIActivityViewController(activityItems: [photoToShare as Any], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete", message: "Do you want to delete the collection?", preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: deleteButtonTapped)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelButtonTapped)
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func deleteButtonTapped(sender: UIAlertAction) -> Void {
        PhotoShared.shared.myPhotoArray!.removeAll()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func cancelButtonTapped(sender: UIAlertAction) -> Void {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    
    //    MARK:- Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoShared.shared.myPhotoArray!.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        let photoCell = cell.viewWithTag(1) as! UIImageView
        photoCell.image = PhotoShared.shared.myPhotoArray![indexPath.row]
        cell.backgroundColor = .white
        
        return cell
    }
    
    
    //    MARK:- Collection View (Scroll View) -
    
    private func findCenterIndex() {
        let center = view.convert(self.myPhotoCollectionView.center, to: self.myPhotoCollectionView)
        if let index = myPhotoCollectionView!.indexPathForItem(at:center) {
            print(index)
            photo.image = PhotoShared.shared.myPhotoArray![index.row]
        }
        print("index not found")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        findCenterIndex()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        findCenterIndex()
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        findCenterIndex()
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        findCenterIndex()
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        findCenterIndex()
    }
    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        findCenterIndex()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PreviewViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController is PreviewViewController {
            viewController.tabBarController?.tabBar.isHidden = true
            viewController.navigationController?.navigationBar.isHidden = false
        }
    }
}

