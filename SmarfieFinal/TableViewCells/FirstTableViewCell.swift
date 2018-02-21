//
//  TableViewCell.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 16/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit

class FirstTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var imageArray: [UIImage] = [#imageLiteral(resourceName: "Front Camera Icon"), #imageLiteral(resourceName: "flash"), #imageLiteral(resourceName: "close"),#imageLiteral(resourceName: "delete"), #imageLiteral(resourceName: "export"), #imageLiteral(resourceName: "export"), #imageLiteral(resourceName: "delete"), #imageLiteral(resourceName: "Video Camera Icon"), #imageLiteral(resourceName: "camera")]
    
    @IBOutlet weak var selfiesCollection: UICollectionView!
    
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
    }
    

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

//    MARK:- COLLECTION VIEW SETUP
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath)
       
        let cellImage = cell.viewWithTag(1) as! UIImageView
        cellImage.image = imageArray[indexPath.row]
//        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
      
        cell.layer.shadowColor = UIColor.blue.cgColor
        cell.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell.layer.shadowOpacity = 0.5
       
        return cell
    }
}

