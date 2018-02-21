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

    @IBOutlet private weak var selfiesCollection: UICollectionView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//     MARK: - COLLECTIONVIEW DELEGATE AND DATASOURCE
        selfiesCollection.delegate = self
        selfiesCollection.dataSource = self
        
  //     MARK: - COLLECTIONVIEW LAYOUT
        let itemSize: Double = Double(UIScreen.main.bounds.width/3 - 15)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(8, 20, 7, 20)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        selfiesCollection.collectionViewLayout = layout
        layout.minimumInteritemSpacing = 2.5
        layout.minimumLineSpacing = 2.5
    }
    

    
    //    MARK:- BOTTOM COLLECTION VIEW SETUP
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
        cell.layer.borderWidth = 0.1
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.cornerRadius = 5
        
        let cellImage = cell.viewWithTag(2) as! UIImageView
        cellImage.image = imageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        myPhoto = imageArray[indexPath.row]
        let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MySelfiesDetailsViewController") as! MySelfiesDetailsViewController
        controller.photo = myPhoto
        let nav = UINavigationController(rootViewController: controller)
        if let source = sourceController {
            source.present(nav, animated: true, completion: nil)
        }
    }

}



