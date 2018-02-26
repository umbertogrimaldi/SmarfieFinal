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
   // let fetchRequestFav: NSFetchRequest<FavouritesPhotos> = FavouritesPhotos.fetchrequest()
    var best = [BestPhotos]()
    var favourites = [FavouritesPhotos]()
    var countBest = 0
    
    func updateBest() {
        do{
            print("aggiorno...")
            let bestSelfie = try PersistenceService.context.fetch(fetchRequest)
            self.best = bestSelfie
            self.countBest = best.count
        }catch {}
        
        
    }
    
    
}

