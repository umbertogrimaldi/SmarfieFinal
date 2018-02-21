//
//  sharedPhoto.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 06/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import Foundation
import UIKit

struct PhotoScore{
    let image: UIImage
    var score: Double?
    let gravity: Double
}



class PhotoShared {
    static let shared = PhotoShared()
    
    var myPhotoArray: [PhotoScore]?
}






