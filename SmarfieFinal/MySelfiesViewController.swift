//
//  MySelfiesViewController.swift
//  myCustomCamera
//
//  Created by UMBERTO GRIMALDI on 17/02/2018.
//  Copyright © 2018 UMBERTO GRIMALDI. All rights reserved.
//

import UIKit

class MySelfiesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         MARK:- DataSource and Delegate
      tableView.dataSource = self
      tableView.delegate = self
      tableView.awakeFromNib()
      tableView.reloadData()
        
        // MARK:- CUSTOM NAVIGATION
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0)]
    UINavigationBar.appearance().tintColor = UIColor(red:0.17, green:0.67, blue:0.71, alpha:1.0)
      
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false

    }
    
    
    //    MARK: UITableViewDatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myRow") as! FirstTableViewCell
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



