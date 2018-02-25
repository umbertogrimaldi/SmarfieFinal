//
//  PreviewViewController.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 05/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit
import CoreData

class PreviewViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  //  let dataPersistanceManager = DataPersistanceManager.shared
    
    @IBOutlet weak var scoreLabel: UILabel!{
        didSet{
            scoreLabel.layer.cornerRadius = 5
            scoreLabel.layer.borderWidth = 0.1
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!{
        didSet{
            descriptionLabel.layer.cornerRadius = 5
            descriptionLabel.layer.borderWidth = 0.1
        }
    }
    
    @IBOutlet weak var myPhotoCollectionView: UICollectionView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var mySessionCollectionView: UIImageView!
    let queue = DispatchQueue(label: "com.smarfie.queue2", qos: .userInitiated)
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
    
    
    
    @IBAction func onTapDone(_ sender: Any) {
        if let _ = PhotoShared.shared.setOfBest {
            PhotoShared.shared.setOfBest!.insert(PhotoShared.shared.myPhotoSession!.first!.image)
            
        }else{
            PhotoShared.shared.setOfBest = [PhotoShared.shared.myPhotoSession!.first!.image]
            
        }
        self.tabBarController?.selectedIndex = 0
        navigationController?.popToRootViewController(animated: true)
        
        PhotoShared.shared.myPhotoSession = nil
        ViewController.sessionState = .closed
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "ReloadCollectionViews"),object: nil))
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(PhotoShared.shared.myPhotoSession!.count)
        myPhotoCollectionView.delegate = self
        myPhotoCollectionView.dataSource = self
        navigationController?.delegate = self
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0)]
       reloadCollectionView()
        
    }
    
    
     func reloadCollectionView() {
        print("finish reload")
        PhotoShared.shared.myPhotoSession!.sort(by: { (lhs:PhotoScore, rhs:PhotoScore) -> Bool in
            
            guard let _ = lhs.score, let  _ = rhs.score else{return false}
            return lhs.score! > rhs.score!
            })
        
        
        let best = BestPhotos(context: PersistenceService.context)
        let imgData = UIImagePNGRepresentation((PhotoShared.shared.myPhotoSession?.first?.image)!)! as NSData
        best.image = imgData
        PersistenceService.saveContext()
        
        

             self.myPhotoCollectionView.reloadData()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func saveToFavourites(_ sender: Any) {
        var photoToSave: PhotoScore?
        let center = view.convert(self.myPhotoCollectionView.center, to: self.myPhotoCollectionView)
        if let index = myPhotoCollectionView!.indexPathForItem(at:center) {
            photoToSave = PhotoShared.shared.myPhotoSession![index.row]
        }
        
        if let _ = PhotoShared.shared.setOfFavourites{
               PhotoShared.shared.setOfFavourites!.insert(photoToSave!.image)
        }else{
               PhotoShared.shared.setOfFavourites = [photoToSave!.image]
        }
         let alert = UIAlertController(title: "OK!", message: "Your photo has been saved as a favourite", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Cool!", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    


    @IBAction func shareTapped(_ sender: Any) {
        var photoToShare: UIImage?
        let center = view.convert(self.myPhotoCollectionView.center, to: self.myPhotoCollectionView)
        if let index = myPhotoCollectionView!.indexPathForItem(at:center) {
            photoToShare = PhotoShared.shared.myPhotoSession![index.row].image
        }
            
        let activityController = UIActivityViewController(activityItems: [photoToShare as Any], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    
    @IBAction func deleteTapped(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Delete", message: "Do you want to delete the collection?", preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            PhotoShared.shared.myPhotoSession = nil
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    //    MARK:- Collection View
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoShared.shared.myPhotoSession!.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath)
        let photoCell = cell.viewWithTag(1) as! UIImageView
        photoCell.image = PhotoShared.shared.myPhotoSession![indexPath.row].image
        cell.backgroundColor = .white
        
        return cell
    }
    
    
    //    MARK:- Collection View (Scroll View) -
    
    private func findCenterIndex() {
        let center = view.convert(self.myPhotoCollectionView.center, to: self.myPhotoCollectionView)
        if let index = myPhotoCollectionView!.indexPathForItem(at:center) {
            photo.image = PhotoShared.shared.myPhotoSession![index.row].image
            if let info = PhotoShared.shared.myPhotoSession![index.row].info{
            descriptionLabel.text = info
            }
            if let score = PhotoShared.shared.myPhotoSession![index.row].score{
                scoreLabel.text = "\(Int(score))%"
                if score < 40{
                    scoreLabel.textColor = .red
                }else if score < 60{
                    scoreLabel.textColor = .yellow
                }else{
                    scoreLabel.textColor = .green
                }
            }
            
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        DispatchQueue.main.async {
            self.findCenterIndex()
        }
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

