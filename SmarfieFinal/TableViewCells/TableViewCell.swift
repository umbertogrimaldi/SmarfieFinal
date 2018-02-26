//
//  TableViewCell.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 17/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var myPhoto: UIImage?
    var sourceController: UIViewController?
    var imageArray: [UIImage] = [#imageLiteral(resourceName: "image1"), #imageLiteral(resourceName: "image2"), #imageLiteral(resourceName: "image3"), #imageLiteral(resourceName: "image4"), #imageLiteral(resourceName: "image5"), #imageLiteral(resourceName: "image6"), #imageLiteral(resourceName: "image7"), #imageLiteral(resourceName: "image8"), #imageLiteral(resourceName: "image9"), #imageLiteral(resourceName: "image10"), #imageLiteral(resourceName: "image11"), #imageLiteral(resourceName: "image12"), #imageLiteral(resourceName: "image13"), #imageLiteral(resourceName: "image14"), #imageLiteral(resourceName: "image15"), #imageLiteral(resourceName: "image16")]
    let voidLayout = UICollectionViewFlowLayout()
    let layout = UICollectionViewFlowLayout()
    var view:UIView?
    @IBOutlet open weak var selfiesCollection: UICollectionView!
    
    @IBOutlet weak var placeholder: UIImageView!
    
    override  func awakeFromNib() {
        super.awakeFromNib()
//     MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE
        selfiesCollection.delegate = self
        selfiesCollection.dataSource = self
        selfiesCollection.register(UINib(nibName:"voidCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "voidCollectionViewCell")
  //     MARK: - COLLECTIONVIEW LAYOUT
        let itemSize: Double = Double(UIScreen.main.bounds.width/3 - 15)
        
        
        layout.sectionInset = UIEdgeInsetsMake(8, 20, 7, 20)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        selfiesCollection.collectionViewLayout = layout
        layout.minimumInteritemSpacing = 2.5
        layout.minimumLineSpacing = 2.5
        voidLayout.itemSize = CGSize(width: 375, height: 233)
       
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollections(_:)), name: Notification.Name("ReloadCollectionViews"), object: nil)
    }
    
    
    @objc func reloadCollections( _ sender: Notification){
        selfiesCollection.reloadData()
    }
    

    
    //    MARK:- BOTTOM COLLECTION VIEW SETUP
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//         if let _ = PhotoShared.shared.setOfFavourites{
//            return PhotoShared.shared.favourites.count
//         }else{
//            return 1
//        }
        return BestSelfie.shared.countFav
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
            cell.layer.borderWidth = 0.1
            cell.layer.borderColor = UIColor.gray.cgColor
            cell.layer.cornerRadius = 5
            let cellImage = cell.viewWithTag(2) as! UIImageView
        if BestSelfie.shared.countFav > 1 { cellImage.image = UIImage(data: BestSelfie.shared.favourites[indexPath.row].image! as Data)}
            return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let _ = PhotoShared.shared.setOfFavourites{
            myPhoto = PhotoShared.shared.favourites[indexPath.row]
            let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MySelfiesDetailsViewController") as! MySelfiesDetailsViewController
            controller.photo = myPhoto
            controller.index = indexPath.row
            controller.photoType = .favourite
            let nav = UINavigationController(rootViewController: controller)
            if let source = sourceController {
                source.present(_:nav, animated:true, completion:nil)
            }
        }else{
            return
        }
       
    }

    
}





