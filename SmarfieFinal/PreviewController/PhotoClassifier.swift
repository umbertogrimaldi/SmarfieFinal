//
//  PhotoClassifier.swift
//  Smarfie
//
//  Created by Michele De Sena on 20/02/2018.
//  Copyright © 2018 Michele De Sena. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import CoreMotion



class PhotoClassifier {
 //   let motionManager = CMMotionManager()
    var faceSide:FaceSide?
//    func startDeviceMotion() -> Double? {
////    var angle:Double{
////        get{
////            self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
////            return self.motionManager.deviceMotion!.gravity.z
////        }
////    }
//        self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
//        return self.motionManager.deviceMotion!.gravity.z
////
//  }
    var isInBestSide:Bool{
        get{
            if let _ = faceSide{
                return faceSide == User.shared.bestSide
            }else{
                return false
            }
        }
    }
    var shutEyes:Bool = false
    var smile:Bool  = false
    var faceAngleScore:Double = 0.0
    var bscore:Double = 0.0
    var totalScore = 0.0
    var faceScore = 0.0
    var score:Double = 0.0
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func detectFaces(image:UIImage)->[CIFaceFeature]{
        let myImage = self.resizeImage(image: image, newWidth: 1000)
        let newImage = CIImage(image:myImage)!
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in:newImage, options: [CIDetectorSmile:true])
        return faces as! [CIFaceFeature]
    }
    
    
    func getBrightness(image:UIImage)->Double{
        return (image.brightness)
    }
    
    
    func calculateScore(image:PhotoScore)->Double{
        totalScore = 0.0
        bscore = 0.0
        faceScore = 0.0
        score = 0.0
        
        let brightness = getBrightness(image: image.image)
        
        let faces = self.detectFaces(image: image.image)
        
        print("Ci sono :\(faces.count) facce \n la gravità è \(image.gravity) ")
        
        if faces.count >= 1 && image.gravity > -0.45{
            for face in faces{
                self.smile = face.hasSmile
                self.shutEyes = !face.leftEyeClosed && !face.rightEyeClosed
                if face.faceAngle > -15 || face.faceAngle < 15 {
                    self.faceAngleScore = abs(Double(face.faceAngle) / 15)
                    self.faceAngleScore = 1 - self.faceAngleScore
                    faceScore += self.faceAngleScore
                    
                }
                if smile{
                    faceScore += 1.0
                }
                
                if shutEyes{
                    faceScore += 1.0
                }
//                faceScore += faceScore
            }
            
          
            
            if faces.count == 1{
                let x = (faces.first!.leftEyePosition.x + faces.first!.rightEyePosition.x) / 2
                let y = faces.first!.bounds.midX
                if x < y - 12 {
                    faceSide = .right
                } else if x > y + 12 {
                    faceSide = .left
                } else {
                    faceSide = .front
                }
                if isInBestSide {
                    faceScore += 1.0
                }
            }
            
              faceScore = faceScore/Double(faces.count)
            
            if brightness > 34 || brightness < 227 {
                bscore = (brightness - 131) / 96
                bscore = 1 - bscore
            }
            
          
            
         
            
            if image.gravity > -0.20 {
                score += 0.35
            } else if image.gravity > 0.20 {
                score += 1.0
            }
        
        print(MotionManager.shared.gravità!)
        print(brightness)
       // print(self.motionManager.deviceMotion!.gravity.z)
        print(smile)
        print(shutEyes)
        print(self.faceAngleScore)
            
            totalScore = (score + bscore + faceScore)
            
            if faces.count == 1 {
                totalScore = totalScore/6
            }else{
                totalScore = totalScore/5
            }
            
            
            
            return totalScore
        } else {
            return 0
        }
    }
    
}




extension CGImage {
    var brightness: Double {
        get {
            let imageData = self.dataProvider?.data
            let ptr = CFDataGetBytePtr(imageData)
            var x = 0
            var result: Double = 0
            for _ in 0..<self.height {
                for _ in 0..<self.width {
                    let r = ptr![0]
                    let g = ptr![1]
                    let b = ptr![2]
                    result += (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
                    x += 1
                }
            }
            let bright = result / Double (x)
            return bright
        }
    }
}
extension UIImage {
    var brightness: Double {
        get {
            return (self.cgImage?.brightness)!
        }
    }
}

public enum FaceSide{
    case right
    case left
    case front
}
