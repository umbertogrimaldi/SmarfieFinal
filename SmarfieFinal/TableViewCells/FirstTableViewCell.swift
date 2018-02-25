//
//  TableViewCell.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 16/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit
import CoreData

class FirstTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var sourceController: UIViewController?
    var imageArray: [UIImage] = [#imageLiteral(resourceName: "image1"), #imageLiteral(resourceName: "image2"), #imageLiteral(resourceName: "image3"), #imageLiteral(resourceName: "image4"), #imageLiteral(resourceName: "image5"), #imageLiteral(resourceName: "image6"), #imageLiteral(resourceName: "image7"), #imageLiteral(resourceName: "image8")]
    @IBOutlet weak var selfiesCollection: UICollectionView!
    
    @IBOutlet weak var placeholder: UIImageView!
    
    
    let fetchRequest: NSFetchRequest<BestPhotos> = BestPhotos.fetchRequest()
    var best = [BestPhotos]()
    
    
    //      MARK:- COLLECTIONVIEW LAYOUT
    
    let voidLayout = UICollectionViewFlowLayout()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//     MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE
        selfiesCollection.delegate = self
        selfiesCollection.dataSource = self
        

        
        
        
//     MARK:- SETTING COLLECTION VIEW INSETS
        var insets = self.selfiesCollection.contentInset
        
        insets.left = 20
        insets.right = 20
        insets.top = 8
        
        self.selfiesCollection.contentInset = insets
        self.selfiesCollection.decelerationRate = UIScrollViewDecelerationRateNormal
        selfiesCollection.backgroundColor = UIColor.white
        selfiesCollection.reloadData()
        voidLayout.itemSize = CGSize(width: 375, height: 233)
         NotificationCenter.default.addObserver(self, selector: #selector(reloadCollections(_:)), name: Notification.Name("ReloadCollectionViews"), object: nil)
    }
    
    
    @objc func reloadCollections( _ sender: Notification){
        selfiesCollection.reloadData()
    }
    
    
//    MARK:- COLLECTION VIEW SETUP
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let best = PhotoShared.shared.setOfBest{
           return best.count
        }else{
           return 1
        }
    }
    
    
   
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        print (PhotoShared.shared.bestPhotos.count)
        
        
        // fetch delle immagini da coredata
        do{
        let bestSelfie = try PersistenceService.context.fetch(fetchRequest)
        self.best = bestSelfie
        }catch {}
        
        // ovviamente restituisce solo se sta qualcosa in setOfBest e quindi va cambiato
        // conviene fare un didload o didAppear ?, aggiornare da coredata l'array e fare il controllo
        
//        if let _ = PhotoShared.shared.setOfBest{
        if best.count > 0 {
             print("in if")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
            let cellImage = cell.viewWithTag(1) as! UIImageView
//            cellImage.image =  PhotoShared.shared.bestPhotos[indexPath.row]
            cellImage.image =  UIImage(data: best[indexPath.row].image! as Data)
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 0.1
            cell.layer.borderColor = UIColor.gray.cgColor
             return cell
        }else{
            print("in else")
//            collectionView.collectionViewLayout = self.voidLayout
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "voidCollectionViewCell", for: indexPath) as! voidCollectionViewCell
            let cellImage = cell.contentView.viewWithTag(0) as! UIImageView
            cellImage.image =  #imageLiteral(resourceName: "Rectangle")
            cell.layer.cornerRadius = 5
            cell.layer.borderWidth = 0.1
            cell.layer.borderColor = UIColor.gray.cgColor
       
             return cell
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = PhotoShared.shared.setOfBest{
            let controller = UIStoryboard(name: "Main",bundle: Bundle.main).instantiateViewController(withIdentifier: "MySelfiesDetailsViewController") as! MySelfiesDetailsViewController
            controller.photo = PhotoShared.shared.bestPhotos[indexPath.row]
            controller.index = indexPath.row
            controller.photoType = .best
            let VC = UINavigationController(rootViewController: controller)
            if let source = sourceController{
                source.present(_:VC,animated:true,completion:nil)
            }
        }else{
            return
        }
        
    }
    
    
}








