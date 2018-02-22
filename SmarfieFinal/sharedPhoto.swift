//
//  sharedPhoto.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 06/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import Foundation
import UIKit

class PhotoScore:Hashable{
    var hashValue: Int = 0
    
    static func ==(lhs: PhotoScore, rhs: PhotoScore) -> Bool {
        return lhs.image == rhs.image
    }
    
    init (image:UIImage,gravity:Double){
        self.image = image
        self.gravity = gravity

    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    required convenience init(imageLiteralResourceName name: String) {
//        fatalError("init(imageLiteralResourceName:) has not been implemented")
//    }
    
    var image: UIImage
    var score: Double?
    var gravity: Double
    
}



class PhotoShared{

    
    static let shared = PhotoShared()
    
    var myPhotoSession: [PhotoScore]?
    
    var bestPhotos:[PhotoScore]{
        get{
            if let _ = setOfBest{
                return setOfBest!.sorted(by: { (lhs, rhs) -> Bool in
                    return lhs.score! > rhs.score!
                })
            }else{
                return []
            }
            
        }
    }
    
    var favourites:[PhotoScore]{
        get{
            if let _ = setOfFavourites{
                return setOfFavourites!.sorted(by: { (lhs, rhs) -> Bool in
                    return lhs.score! > rhs.score!
                })
            }else{
                return []
            }
          
        }
    }
    
    var setOfBest:Set<PhotoScore>?
    
   
    var setOfFavourites:Set<PhotoScore>?
}






