//
//  Network Manager.swift
//  Newsville
//
//  Created by Vinayak Pal on 04/04/19.
//  Copyright © 2019 Vinayak Pal. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper
import Alamofire
import RxAlamofire

class NetworkManagerModel {
    
    var category: String = ""
    var page: Int = 1
    var query: String = ""
    
    private let disposeBag = DisposeBag()
    var trendingNewsFeedBRelay: BehaviorRelay<[NewsArticleData]> = BehaviorRelay(value: [])
    var latestNewsFeedBRelay: BehaviorRelay<[NewsArticleData]> = BehaviorRelay(value: [])
    var searchNewsFeedBRelay: BehaviorRelay<[NewsArticleData]> = BehaviorRelay(value: [])
    
    var latestNewsApiResponse: BehaviorRelay<String> = BehaviorRelay(value: "")
    var searchNewsApiResponse: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    // Hitting Api for collection view trending results
    func trendingFeedModelApi() {
        
        let fetchApi = GetTrendingNewsApi()
        let keys = ["q","apiKey","pageSize"]
        let values = ["trending",Constants.apiKey,"5"]
        
        fetchApi.queryKeys.append(contentsOf: keys)
        fetchApi.queryValues.append(contentsOf: values)
        
        let urlString = fetchApi.createUrlString()
        
        RxAlamofire.json(.get, urlString, parameters: nil, encoding: JSONEncoding.default, headers: Constants.header).asObservable().subscribe(onNext: { json in
            
            if let json = json as? [String: Any] {
                
                let fetchData = Mapper<NewsFeedMap>().map(JSON: json)
                
                if let article = fetchData?.article {
                    self.trendingNewsFeedBRelay.accept(article)
                }
            }
            
        }, onError: { (_) in

        }).disposed(by: self.disposeBag)
        
    }
    
    // Hitting Api for main feed results
    func latestFeedModelApi() {
        
        let fetchApi = GetLatestNewsApi()
        
        fetchApi.queryKeys.append("apiKey")
        fetchApi.queryValues.append(Constants.apiKey)
        
        fetchApi.queryKeys.append("pageSize")
        fetchApi.queryValues.append("10")
        
        if query != "" {
            fetchApi.queryKeys.append("q")
            fetchApi.queryValues.append(query)
        }else {
            fetchApi.queryKeys.append("country")
            fetchApi.queryValues.append("in")
        }
        
        if category != "" {
            fetchApi.queryKeys.append("category")
            fetchApi.queryValues.append(category)
        }
        
        fetchApi.queryKeys.append("page")
        fetchApi.queryValues.append(String(page))
        
        let urlString = fetchApi.createUrlString()
   
        RxAlamofire.json(.get, urlString, parameters: nil, encoding: JSONEncoding.default, headers: Constants.header).asObservable().subscribe(onNext: { json in
            
            if let json = json as? [String: Any] {
                
                let fetchData = Mapper<NewsFeedMap>().map(JSON: json)
                
                if let article = fetchData?.article {
                    self.latestNewsFeedBRelay.accept(article)
                    
                    if article.count == 0 && self.page == 1 {
                        self.latestNewsApiResponse.accept(Constants.feedUnavailable)
                    }
                }
            }
            
        }, onError: { (_) in
            
            self.latestNewsApiResponse.accept(Constants.networkError)
            
        }).disposed(by: self.disposeBag)
    }
    
    // Hitting Api for searched result
    func searchFeedModelApi() {
        
        let fetchApi = GetTrendingNewsApi()
        let keys = ["q","apiKey","pageSize","page"]
        let values = [query,Constants.apiKey,"10",String(page)]
        
        fetchApi.queryKeys.append(contentsOf: keys)
        fetchApi.queryValues.append(contentsOf: values)
        
        let urlString = fetchApi.createUrlString()
        
        RxAlamofire.json(.get, urlString, parameters: nil, encoding: JSONEncoding.default, headers: Constants.header).asObservable().subscribe(onNext: { json in
            
            if let json = json as? [String: Any] {
                
                let fetchData = Mapper<NewsFeedMap>().map(JSON: json)
                
                if let article = fetchData?.article {
                    self.searchNewsFeedBRelay.accept(article)
                    
                    if article.count == 0 && self.page == 1 {
                        self.searchNewsApiResponse.accept(Constants.feedUnavailable)
                    }
                }
            }
            
        }, onError: { _ in
            
            self.searchNewsApiResponse.accept(Constants.networkError)
            
        }).disposed(by: self.disposeBag)
        
    }
}
