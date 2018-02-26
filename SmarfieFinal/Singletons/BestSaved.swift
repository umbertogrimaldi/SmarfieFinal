//
//  BestSaved.swift
//  SmarfieFinal
//
//  Created by Antonio Cerqua on 25/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class BestSelfie {
    static let shared = BestSelfie()
    //var savedInData = [UIImage]()
    let fetchRequest: NSFetchRequest<BestPhotos> = BestPhotos.fetchRequest()
    var best = [BestPhotos]()
    var countBest = 0
    let bestSelfie = BestPhotos(context: PersistenceService.context)
    
    func updateBest() {
        do{
            print("aggiorno...")
            let bestSelfie = try? PersistenceService.context.fetch(fetchRequest)
            self.best = bestSelfie!
            self.countBest = best.count
        }catch {}
        
        
    }
    
    func saveBeast(photo:UIImage){
        print ("salvo")
        let pngRep = photo.fixOrientation()
        let imgData = UIImagePNGRepresentation(pngRep)! as NSData
        bestSelfie.image = imgData
        PersistenceService.saveContext()
        self.updateBest()
    }
    
    
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
}
