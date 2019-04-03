//
//  RearSidePanelVC.swift
//  Newsville
//
//  Created by Vinayak Pal on 03/04/19.
//  Copyright © 2019 Vinayak Pal. All rights reserved.
//

import UIKit

class RearSidePanelVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkHeaderViewHeight()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    func checkHeaderViewHeight() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = UINavigationController().navigationBar.frame.height
        let navHeight: CGFloat = statusBarHeight + navBarHeight
        if navHeight > 64 {
            headerViewHeight.constant = 135
        }else {
            headerViewHeight.constant = 110
        }
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
}

extension RearSidePanelVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = sb.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        let frontVC = UINavigationController(rootViewController: homeVC)
        let revealVC = self.revealViewController()
        let category = Category.list[indexPath.item]
        
        homeVC.category = category["name"] ?? ""
        revealVC?.pushFrontViewController(frontVC, animated: true)
        
        
    }
    
}

extension RearSidePanelVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Category.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        
        let category = Category.list[indexPath.item]
        
        cell.baseView.backgroundColor = UIColor(hex: category["colour"] ?? "ffffff")
        cell.categoryLabel.text = category["name"]?.capitalized
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}
