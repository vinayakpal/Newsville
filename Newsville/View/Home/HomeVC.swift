//
//  HomeVC.swift
//  Newsville
//
//  Created by Vinayak Pal on 03/04/19.
//  Copyright © 2019 Vinayak Pal. All rights reserved.
//

import UIKit
import SWRevealViewController

class HomeVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    var category: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callsidePanel()
        setupCollectonView()
        setupCollectionViewFlowLayout()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    // Nav Bar left menu button action
    func callsidePanel() {
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(self.revealViewController()?.revealToggle(_:))
        }
    }
    
    // collectionview flowlayout settlement
    func setupCollectionViewFlowLayout() {
        collectionViewFlowLayout.minimumLineSpacing = 0.0
        collectionViewFlowLayout.minimumInteritemSpacing = 0.0
        let itemSize = CGSize(width: self.view.frame.width, height: 180)
        collectionViewFlowLayout.itemSize = itemSize
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    // intitalise collectionview
    func setupCollectonView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let collectionNib = UINib(nibName: "TrendingCollectionViewCell", bundle: nil)
        collectionView.register(collectionNib, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    // initialise tableview
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        let feedNib = UINib(nibName: "NewsFeedTableViewCell", bundle: nil)
        tableView.register(feedNib, forCellReuseIdentifier: "FeedCell")
    }
}

// extension for colletion view delegate methods
extension HomeVC: UICollectionViewDelegate {
    
}

// extension for colletion view datasource methods
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! TrendingCollectionViewCell
        
        return cell
    }
}

// extension for table view datasource methods
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! NewsFeedTableViewCell
        
        cell.feedImageView.image = UIImage(named: "dims")
        cell.sourceNameLabel.text = "Timesnews.com"
        cell.feedTitleLabel.text = "Election 2019: EC Issues Notice to Yogi Over ‘Modi ki Sena’ Remark - The Quint"
        cell.feedAuthorLabel.text = "The Quint"
        cell.feedPublishLabel.text = "1 week ago"
        cell.feedDescLabel.text = "Election 2019 Countdown LIVE Updates: Election Commission issues notice to Uttar Pradesh Chief Minister Yogi Adityanath over his ‘Modi ki sena’ remarks, made during a speech. Commission has asked him to file a reply by 5 April."
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}

// extension for colletion view delegate methods
extension HomeVC:UITableViewDelegate {
    
}
