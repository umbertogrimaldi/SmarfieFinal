//
//  DataController.swift
//  SmarfieFinal
//
//  Created by Antonio Cerqua on 23/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataController {
    static let shared = CoreDataController()
    
    private var context: NSManagedObjectContext
    
    private init() {
        let application = UIApplication.shared.delegate as! AppDelegate
        self.context = application.persistentContainer.viewContext
    }
}
