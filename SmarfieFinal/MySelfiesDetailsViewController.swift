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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImage.image = photo
        navigationController?.delegate = self
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.topItem?.title = "Collection"
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
    
    let alertController = UIAlertController(title: "Delete", message: "Do you want to delete the collection?", preferredStyle: .actionSheet)
        
        let deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: deleteTapped)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteTapped(sender: UIAlertAction) -> Void {
        //       FIXME: - ADD FUNCTION
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



