//
//  ViewController.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 05/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var currentCameraPosition: CameraPosition?
    var frontCameraInput:AVCaptureInput?
    var backCameraInput:AVCaptureInput?
    var captureSession = AVCaptureSession()
    var frontCamera: AVCaptureDevice?
    var backCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    var photoLayer:CGRect?
    var photoOutput: AVCapturePhotoOutput?
    var currentLayer:PhotoLayer = .rectangular
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    let photoSettings = AVCapturePhotoSettings()
    var flashMode = AVCaptureDevice.FlashMode.auto
    var image: UIImage?
    var rectangularFrame:CGRect?
    var squaredFrame:CGRect?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    //    MARK:- Outlets
    
    @IBOutlet weak var photoCounter: UILabel!
    @IBOutlet weak var photoLittle: UIImageView!
    @IBOutlet weak var squareButton: UIButton!
    @IBOutlet weak var rectButton: UIButton!
    @IBOutlet weak var counterView: UIView!
    
    
    @IBOutlet weak var flashButton: UIButton! {
        didSet{
            flashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        }
    }
    @IBOutlet weak var switchCameraButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        
        takePhotoButton.layer.borderWidth = 6
        takePhotoButton.layer.borderColor = UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0).cgColor
        takePhotoButton.layer.cornerRadius = 37.5
        
        counterView.layer.cornerRadius = 5
        counterView.layer.opacity = 30
        counterView.layer.borderColor = UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0).cgColor
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        photoLittle.image = nil
        photoCounter.text = "\(0)"
    }
    
    
    @IBAction func switchFrameRect(_ sender: UIButton) {
        self.currentLayer = .rectangular
        cameraPreviewLayer?.frame = rectangularFrame!
        if self.currentLayer == .rectangular {
            rectButton.setTitleColor(UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0), for: .normal)
            squareButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
    @IBAction func switchFrameSquare(_ sender: Any) {
        self.currentLayer = .squared
        cameraPreviewLayer?.frame = squaredFrame!
        if self.currentLayer == .squared {
            squareButton.setTitleColor(UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0), for: .normal)
            rectButton.setTitleColor(UIColor.gray, for: .normal)
        }
    }
    
    
    //    MARK:- FUNCTIONS
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
            
            try? device.lockForConfiguration()
            if (device.isFocusModeSupported(.continuousAutoFocus)){
                device.focusMode = .continuousAutoFocus
            } else if (device.isFocusModeSupported(.autoFocus)){
                device.focusMode = .autoFocus
            }
            device.unlockForConfiguration()
        }
    }
    
    
    func setupInputOutput() {
        
        if let rearCamera = self.backCamera {
            self.backCameraInput = try? AVCaptureDeviceInput(device: rearCamera)
            
            if captureSession.canAddInput(self.backCameraInput!) { captureSession.addInput(self.backCameraInput!) }else {print ("Cannot add back input")}
            
            self.currentCameraPosition = .rear
            self.switchCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
            
        } else if let frontCamera = self.frontCamera {
            self.frontCameraInput = try? AVCaptureDeviceInput(device: frontCamera)
            
            if captureSession.canAddInput(self.frontCameraInput!) { captureSession.addInput(self.frontCameraInput!) }
            else { print ("cannot add front input")}
            
            self.currentCameraPosition = .front
            self.switchCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
        }
        
        photoOutput = AVCapturePhotoOutput()
        photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        captureSession.addOutput(photoOutput!)
    }
    
    
    func setupPreviewLayer() {
        squaredFrame = CGRect(x: 0, y:(view.bounds.height * 0.21889)-10, width: view.bounds.width, height: view.bounds.width)
        rectangularFrame = CGRect(x:0,y:(view.bounds.height*0.133433)-40,width:view.bounds.width, height:view.bounds.width / 0.75)
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        switch self.currentLayer {
        case .rectangular:
        cameraPreviewLayer?.frame = rectangularFrame!
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
            
        case .squared:
            cameraPreviewLayer?.frame = squaredFrame!
            self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
        }
    }
    
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    
    //    MARK: - buttons
    
    @IBAction func changeCamera(_ sender: Any) {
        try? self.switchCameras()
        switch self.currentCameraPosition{
        case .some(.front):
            switchCameraButton.setImage(#imageLiteral(resourceName: "Front Camera Icon"), for: .normal)
        case .some(.rear):
            switchCameraButton.setImage(#imageLiteral(resourceName: "Rear Camera Icon"), for: .normal)
        case .none:
            return
        }
    }
    
    
    func switchCameras() throws {
        guard let currentCameraPosition = currentCameraPosition else {print("Camera position error"); return}
        guard captureSession.isRunning else { print ("errore");return }
        
        captureSession.beginConfiguration()
        
        
        func switchToFrontCamera() {
            let inputs = captureSession.inputs as [AVCaptureInput]
            guard let rearCameraInput = self.backCameraInput, inputs.contains(rearCameraInput),
                let frontCamera = self.frontCamera else {
                    print("Error3")
                    return}
            
            self.frontCameraInput = try? AVCaptureDeviceInput(device: frontCamera)
            
            captureSession.removeInput(rearCameraInput)
            
            if captureSession.canAddInput(self.frontCameraInput!) {
                captureSession.addInput(self.frontCameraInput!)
                
                self.currentCameraPosition = .front
            }
                
            else {
                //
                print("Error4")
                return
            }
        }
        
        func switchToRearCamera() {
            let inputs = captureSession.inputs as [AVCaptureInput]
            guard let frontCameraInput = self.frontCameraInput else{print("no front camera input"); return}
            guard inputs.contains(frontCameraInput)else {print ("No contains"); return}
            guard let rearCamera = self.backCamera else {
                print("no back camera")
                return }
            
            self.backCameraInput = try? AVCaptureDeviceInput(device: rearCamera)
            
            captureSession.removeInput(frontCameraInput)
            
            if captureSession.canAddInput(self.backCameraInput!) {
                captureSession.addInput(self.backCameraInput!)
                
                self.currentCameraPosition = .rear
                
            } else {
                print("Error 2")
                return }
        }
        
        switch currentCameraPosition {
        case .front:
            switchToRearCamera()
        case .rear:
            switchToFrontCamera()
        }
        captureSession.commitConfiguration()
    }
    
    
    @IBAction func cameraButton(_ sender: Any) {
        photoSettings.flashMode = self.flashMode
        let uniCameraSetting = AVCapturePhotoSettings.init(from: photoSettings)
        photoOutput?.capturePhoto(with: uniCameraSetting, delegate: self)
        
    }
    
    
    @IBAction func flashButton(_ sender: Any) {
        switch self.flashMode{
        case .on:
            self.flashMode = .off
            self.flashButton.setImage(#imageLiteral(resourceName: "Flash Off Icon"), for: .normal)
        case .off :
            self.flashMode = .auto
            self.flashButton.setImage(nil, for: .normal)
            self.flashButton.setTitle("Auto", for: .normal)
        case .auto:
            self.flashMode = .on
            self.flashButton.setTitle(nil, for: .normal)
            self.flashButton.setImage(#imageLiteral(resourceName: "Flash On Icon"), for: .normal)
        }
    }
    
    
    @IBAction func dismissButton(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    
    @IBAction func showPhoto(_ sender: UIButton) {
        if let _ = PhotoShared.shared.myPhotoArray {
            performSegue(withIdentifier: "mySegue", sender: self)
        } else {
            let alertController = UIAlertController(title: "No Photos", message: "Take at least one selfie", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


//MARK:- CAMERA POSITION ENUMERATION
public enum CameraPosition {
    case front
    case rear
}


//MARK:- Extension ViewController to take photo

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let imageData = photo.fileDataRepresentation() {
            print(imageData)
            image = UIImage(data: imageData)
            if let _ = PhotoShared.shared.myPhotoArray {
                PhotoShared.shared.myPhotoArray!.append(image!)
            } else {
                PhotoShared.shared.myPhotoArray = [image!]
            }
            
//            print(PhotoShared.shared.myPhotoArray.count)
            UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
            photoLittle.image = PhotoShared.shared.myPhotoArray!.last
            photoCounter.text = "\(PhotoShared.shared.myPhotoArray!.count)"
        }
    }
}

// MARK:- Hidden TabBar and Nav bar

extension ViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController is ViewController {
            viewController.tabBarController?.tabBar.isHidden = true
            viewController.navigationController?.navigationBar.isHidden = true
        } else {
            viewController.tabBarController?.tabBar.isHidden = false
            viewController.navigationController?.navigationBar.isHidden = false
        }
    }
}


public enum PhotoLayer{
    case squared
    case rectangular
}
