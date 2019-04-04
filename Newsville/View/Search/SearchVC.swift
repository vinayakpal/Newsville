//
//  SearchVC.swift
//  Newsville
//
//  Created by Vinayak Pal on 04/04/19.
//  Copyright © 2019 Vinayak Pal. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import UIView_Shimmer

class SearchVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    let searchBar = UISearchBar()
    let newsFeedViewModel = NewsFeedViewModel()
    
    var searchBarButton = UIBarButtonItem()
    var searchFeedArray: [NewsArticleData] = []
    var searchString: String = ""
    var pageCount = 1
    var isApiCall: Bool = true
    var isResponseObserved: Bool = true
    var isFooterCall: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupSearchBarButton()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func setupSearchBar() {
        searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
        searchBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.becomeFirstResponder()
        searchBar.placeholder = "Search News"
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.init(name: "Ubuntu-Regular", size: 16)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).font = UIFont.init(name: "Ubuntu-Regular", size: 16)
        
    }
    
    func setupSearchBarButton() {
        searchBarButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        
        UIView.animate(withDuration: 0, animations: {
            
            self.searchBarButton.rx.tap.subscribe(onNext:{
                
                self.setupSearchBar()
                self.searchBar.setShowsCancelButton(true, animated: true)
                self.searchBar.becomeFirstResponder()
                self.navigationItem.rightBarButtonItems = []
                self.searchBar.text = ""
                
            }).disposed(by: self.disposeBag)
            
        }, completion: nil)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 350
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        let feedNib = UINib(nibName: "NewsFeedTableViewCell", bundle: nil)
        tableView.register(feedNib, forCellReuseIdentifier: "FeedCell")
        
    }
    
    func observeLatestSearchNews(with query: String) {
        
        self.searchFeedArray.removeAll()
        self.addShimmerHeader(of: tableView)
        self.removeShimmerFooter(of: tableView)
        isFooterCall = true
        self.tableView.reloadData()
        
        pageCount = 1
        newsFeedViewModel.category = ""
        newsFeedViewModel.page = pageCount
        newsFeedViewModel.query = query
        
        newsFeedViewModel.searchFeedDataBinding()
        
        if isResponseObserved {
            isResponseObserved = false
            newsFeedViewModel.searchNewsFeedBRObservable?.subscribe(onNext: { (response) in
                
                if response.count == 0 && self.searchFeedArray.count > 0 {
                    self.isApiCall = false
                    self.removeShimmerFooter(of: self.tableView)
                }else {
                    self.isApiCall = true
                    self.searchFeedArray += response
                    self.tableView.reloadData()
                }
                
            }).disposed(by: self.disposeBag)
            
            newsFeedViewModel.searchNewsResponseObservable?.subscribe(onNext: { (response) in
                
                if self.searchFeedArray.count == 0 && response.contains(Constants.feedUnavailable) {
                    print("No News Feed")
                    self.removeShimmerHeader(of: self.tableView)
                    self.removeShimmerFooter(of: self.tableView)
                    self.showAlert(msg: "We didn't find any result for\n\(self.searchString)")
                }else if self.searchFeedArray.count == 0 && response.contains(Constants.networkError)  {
                    print("Network error")
                    self.removeShimmerHeader(of: self.tableView)
                    self.removeShimmerFooter(of: self.tableView)
                    self.showAlert(msg: "It seems you're out of Internet Connection")
                }else {
                    // do nothing
                }
                
            }).disposed(by: self.disposeBag)
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        if let searchQuery = searchBar.text {
            searchBar.resignFirstResponder()
            self.navigationItem.rightBarButtonItem = searchBarButton
            self.navigationItem.titleView = self.setTitle(title: "Search Results for", subtitle: "\(searchQuery)")
            self.searchString = searchQuery
            self.observeLatestSearchNews(with: searchQuery)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        if searchString != "" {
            searchBar.resignFirstResponder()
            self.navigationItem.rightBarButtonItem = searchBarButton
            self.navigationItem.titleView = self.setTitle(title: "Search Results for", subtitle: "\(searchString)")
        }else {
            searchBar.resignFirstResponder()
            navigationController?.popViewController(animated: true)
        }
    }
}

extension SearchVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let searchedNews = self.searchFeedArray[indexPath.item]
        let feedUrl = searchedNews.feedUrl
        self.openUrl(urlString: feedUrl)
    }
}

extension SearchVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchFeedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as! NewsFeedTableViewCell
        
        self.removeShimmerHeader(of: tableView)
        
        if searchFeedArray.count > 9 && isFooterCall {
            isFooterCall = false
            self.addShimmerFooter(of: tableView)
        }
        
        let latestNews = self.searchFeedArray[indexPath.item]
        
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
        
        if indexPath.item == searchFeedArray.count - 1 && isApiCall {
            isApiCall = false
            pageCount += 1
            newsFeedViewModel.category = ""
            newsFeedViewModel.page = pageCount
            newsFeedViewModel.query = searchString
            
            newsFeedViewModel.searchFeedDataBinding()
        }
        
        cell.selectionStyle = .none
        return cell
    }
}

extension SearchVC {
    
    
}
