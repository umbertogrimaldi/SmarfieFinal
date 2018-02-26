//
//  MySelfiesViewController.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 17/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit
import CoreData

class MySelfiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    let emptyView = EmptyView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = CGRect(x: 0, y: 0, width: 375, height: #imageLiteral(resourceName: "Group").size.height)
        emptyView.frame = frame
        
//         MARK:- DataSource and Delegate
      tableView.dataSource = self
      tableView.delegate = self
        
        
        // MARK:- CUSTOM NAVIGATION
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0)]
    UINavigationBar.appearance().tintColor = UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0)
        
        NotificationCenter.default.addObserver(self, selector: #selector (reloadData(_:)), name: NSNotification.Name(rawValue: "ReloadCollectionViews"), object: nil)
        if PhotoShared.shared.favourites.count == 0 && PhotoShared.shared.bestPhotos.count == 0{
            self.view.addSubview(emptyView)
            
        }
    }
    
    @objc func reloadData(_ sender: Notification){
        print("reloading...")
        tableView.reloadData()
    }
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.bringSubview(toFront: emptyView)
        
        if BestSelfie.shared.best.count > 1{
            emptyView.removeFromSuperview()
        }else if  let _ = PhotoShared.shared.setOfFavourites{
             emptyView.removeFromSuperview()
        }
        
//        if let _ = PhotoShared.shared.setOfBest {
//              emptyView.removeFromSuperview()
//        }else if let _ = PhotoShared.shared.setOfFavourites{
//            emptyView.removeFromSuperview()
//        }
      
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false

    }
    
    
    //    MARK: UITableViewDatasource
    func numberOfSections(in tableView: UITableView) -> Int {
          var sections = 0
        if  BestSelfie.shared.best.count>1{
            sections += 1
        }
        if  BestSelfie.shared.countFav>1{
            sections += 1
        }
        return  sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myRow") as! FirstTableViewCell
            cell.sourceController = self
        return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myRow2") as! TableViewCell
            cell.sourceController = self
            return cell
        }
    }
    
    //    MARK: - MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 233
        } else {
            return tableView.contentSize.height
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.white
            
           let headerLabel = UILabel()
            headerLabel.font = .systemFont(ofSize: 25, weight: .medium)
            headerLabel.textColor = UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0)
            headerLabel.text = "Best Ones"
            headerLabel.sizeToFit()
            headerView.addSubview(headerLabel)
            headerLabel.frame = headerLabel.frame.offsetBy(dx: 20, dy: 15)
            
            return headerView
        } else {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.white
            
            let headerLabel = UILabel()

            headerLabel.font = .systemFont(ofSize: 25, weight: .medium)
            headerLabel.textColor = UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0)
            headerLabel.text = "Favourites"
            headerLabel.sizeToFit()
            headerView.addSubview(headerLabel)
            headerLabel.frame = headerLabel.frame.offsetBy(dx: 20, dy: 15)
            return headerView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}



extension MySelfiesViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController is MySelfiesViewController {
            viewController.tabBarController?.tabBar.isHidden = false
            viewController.navigationController?.navigationBar.isHidden = false
        }
    }
}



