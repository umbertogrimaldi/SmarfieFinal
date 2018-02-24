//
//  sharedPhoto.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 06/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PhotoScore:Hashable{
    var hashValue: Int = 0
    var image: UIImage
    var score: Double?
    var gravity: Double
    
    
    static func ==(lhs: PhotoScore, rhs: PhotoScore) -> Bool {
        return lhs.image == rhs.image
    }
    
    init (image:UIImage,gravity:Double){
        self.image = image
        self.gravity = gravity

    }

    
 
}




class PhotoShared{

    
    static let shared = PhotoShared()
    let fetchRequest: NSFetchRequest<BestPhotos> = BestPhotos.fetchRequest()
    var best = [BestPhotos]()
    
    
    
    
    var myPhotoSession: [PhotoScore]?
    
  //  var bestPhotos: [UIImage]?
    // Commentato xkè mi serve di tipo UIimage per farla uscire nell cella -- a causa del retrieving da coreData
    
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
    
//    func updateBest(){
//        do{
//            let bestSelfie = try PersistenceService.context.fetch(fetchRequest)
//            self.best = bestSelfie
//            for best in bestSelfie{
//                bestPhotos?.append(UIImage(data: best.image! as Data)!)
//            }
//        }catch {}
//        
//       
//        
//    }
    
    
    
    var setOfBest:Set<PhotoScore>?
    
   
    var setOfFavourites:Set<PhotoScore>?
}






