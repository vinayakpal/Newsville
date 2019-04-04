//
//  HomeVC.swift
//  Newsville
//
//  Created by Vinayak Pal on 03/04/19.
//  Copyright © 2019 Vinayak Pal. All rights reserved.
//

import UIKit
import SWRevealViewController
import RxSwift
import RxCocoa
import SDWebImage

class HomeVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var pageControl: UIPageControl!
    
    let newsFeedViewModel = NewsFeedViewModel()
    private let disposeBag = DisposeBag()
    
    var category: String = ""
    var trendingFeedArray: [NewsArticleData] = []
    var latestFeedArray: [NewsArticleData] = []
    var isApiCall: Bool = true
    var pageCount: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callNavBarElements()
        setupCollectonView()
        setupCollectionViewFlowLayout()
        setupTableView()
        
        observeTrendingNewsFeeds()
        observeLatestNewsFeeds()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    // Nav Bar left menu button action
    func callNavBarElements() {
        // left menu button action
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(self.revealViewController()?.revealToggle(_:))
        }
        // view gesture to open side panel
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        // searchbar button action
        searchButton
            .rx
            .tap
            .subscribe(onNext : {
            // present searchViewController when search button is clicked
            let searchVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            self.navigationController?.pushViewController(searchVC, animated: true)
        }).disposed(by: self.disposeBag)
        
        // setting navabar center image
        let logoImage = UIImage(named: "newsville_nav")
        self.navigationItem.titleView = UIImageView(image: logoImage)
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    // collectionview flowlayout settlement
    func setupCollectionViewFlowLayout() {
        collectionViewFlowLayout.minimumLineSpacing = 0.0
        collectionViewFlowLayout.minimumInteritemSpacing = 0.0
        let itemSize = CGSize(width: self.view.frame.width, height: 180)
        collectionViewFlowLayout.itemSize = itemSize
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        pageControl.isHidden = true
    }
    
    // intitalise collectionview
    func setupCollectonView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        let collectionNib = UINib(nibName: "TrendingCollectionViewCell", bundle: nil)
        collectionView.register(collectionNib, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    // initialise Page Control (collection dots)
    func setupPagingControl(pages : Int){
        pageControl.isUserInteractionEnabled = false
        pageControl.numberOfPages = pages
        pageControl.isHidden = false
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
        self.addShimmerFooter(of: tableView)
    }
    
    func observeTrendingNewsFeeds() {
        
        newsFeedViewModel.trendingFeedDataBinding()
        
        newsFeedViewModel.trendingNewsFeedBRObservable?.subscribe(onNext: { (response) in
            
            if response.count > 0 {
                self.trendingFeedArray = response
                self.collectionView.reloadData()
                self.setupPagingControl(pages: self.trendingFeedArray.count)
            }
            
        }).disposed(by: self.disposeBag)
        
    }
    
    func observeLatestNewsFeeds() {
        pageCount = 1
        newsFeedViewModel.category = category
        newsFeedViewModel.page = pageCount
        newsFeedViewModel.query = ""
        newsFeedViewModel.latestFeedDataBinding()
        
        newsFeedViewModel.latestNewsFeedBRObservable?.subscribe(onNext: { (response) in
            
            if response.count == 0 && self.latestFeedArray.count > 0 {
                self.isApiCall = false
                self.removeShimmerFooter(of: self.tableView)
            }else {
                self.isApiCall = true
                self.latestFeedArray += response
                self.tableView.reloadData()
            }
            
        }).disposed(by: self.disposeBag)
    }
}

// extension for colletion view delegate methods
extension HomeVC: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentIndex = self.collectionView.contentOffset.x/self.view.frame.width
        pageControl.currentPage = Int(currentIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let trendingNews = self.trendingFeedArray[indexPath.item]
        let feedUrl = trendingNews.feedUrl
        self.openUrl(urlString: feedUrl)
    }
}

// extension for colletion view datasource methods
extension HomeVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendingFeedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! TrendingCollectionViewCell
        
        let trendingNews = trendingFeedArray[indexPath.item]
        
        cell.trendingTitleLabel.text = trendingNews.title
        
        let urlString = trendingNews.imageUrl
        if let imageUrl = URL(string: urlString) {
            cell.trendingImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
        
        
        return cell
    }
}

// extension for table view datasource methods
extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latestFeedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! NewsFeedTableViewCell
        
        let latestNews = self.latestFeedArray[indexPath.item]
        
        if let sourceName = latestNews.source?.name, sourceName != "" {
            cell.sourceBaseView.isHidden = false
            cell.sourceNameLabel.text = sourceName
        }else {
            cell.sourceBaseView.isHidden = true
        }
        
        cell.feedAuthorLabel.text = latestNews.author
        cell.feedTitleLabel.text = latestNews.title
        cell.feedPublishLabel.text = latestNews.publishedAt
        cell.feedDescLabel.text = latestNews.description
        
        let urlString = latestNews.imageUrl
        if let imageUrl = URL(string: urlString) {
            cell.feedImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"))
        }
        
        if indexPath.item == latestFeedArray.count - 1 && isApiCall {
            self.isApiCall = false
            pageCount += 1
            newsFeedViewModel.category = category
            newsFeedViewModel.page = pageCount
            newsFeedViewModel.query = ""
            
            newsFeedViewModel.latestFeedDataBinding()
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}

// extension for colletion view delegate methods
extension HomeVC:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let latestNews = self.latestFeedArray[indexPath.item]
        let feedUrl = latestNews.feedUrl
        self.openUrl(urlString: feedUrl)
    }
}
