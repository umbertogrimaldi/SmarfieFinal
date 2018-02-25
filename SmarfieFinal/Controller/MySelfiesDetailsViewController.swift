//
//  MySelfiesDetailsViewController.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 16/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit

class MySelfiesDetailsViewController: UIViewController {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    var photo: UIImage?
    var index: Int?
    var photoType:PhotoType?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImage.image = photo
        navigationController?.delegate = self
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0)]
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backTapped))
    }
    
    @objc func backTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }

    
    //    MARK:- SETUP THE TOOLBAR DELETE BUTTON
    @IBAction func toolbarDeleteTapped(_ sender: Any) {
    
    let alertController = UIAlertController(title: "Delete", message: "Do you want to delete this photo?", preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            if self.photoType! == .favourite{
                guard let favs = PhotoShared.shared.setOfFavourites else {return}
                if let index = favs.index(of:self.photo!){
                    PhotoShared.shared.setOfFavourites!.remove(at:index)
                    print(favs.count)
                    if favs.count == 1 {PhotoShared.shared.setOfFavourites = nil}
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue:"ReloadCollectionViews"), object: nil))
                    self.dismiss(animated: true, completion: nil)
                }
            }else {
                guard let bests = PhotoShared.shared.setOfBest else {return}
                if let index = bests.index(of:self.photo!){
                    PhotoShared.shared.setOfBest!.remove(at:index)
                    print("aaaaaaaaaa",bests.count)
                    if bests.count == 1 {PhotoShared.shared.setOfBest = nil}
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue:"ReloadCollectionViews"), object: nil))
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
 

    
    
    //    MARK:- MARK:- SETUP THE TOOLBAR DELETE BUTTON
    @IBAction func toolbarShareTapped(_ sender: Any) {
        if let photoToShare = photo {
            let activityController = UIActivityViewController(activityItems: [photoToShare as Any], applicationActivities: nil)
            self.present(activityController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


extension MySelfiesDetailsViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        if viewController is MySelfiesDetailsViewController {
            viewController.tabBarController?.tabBar.isHidden = true
        }
    }
}

 enum PhotoType{
    case favourite
    case best
}

