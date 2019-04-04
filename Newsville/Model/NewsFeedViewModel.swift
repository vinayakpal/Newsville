//
//  NewsFeedViewModel.swift
//  Newsville
//
//  Created by Vinayak Pal on 04/04/19.
//  Copyright © 2019 Vinayak Pal. All rights reserved.
//

import Foundation
import RxSwift
import ObjectMapper

class NewsFeedViewModel {
    
    let newsFeedModel = NetworkManagerModel()
    var category: String = ""
    var page: Int = 1
    var query: String = ""
    var trendingNewsFeedBRObservable: Observable<[NewsArticleData]>?
    var latestNewsFeedBRObservable: Observable<[NewsArticleData]>?
    
    func trendingFeedDataBinding() {
        
        newsFeedModel.trendingFeedModelApi()
        trendingNewsFeedBRObservable = newsFeedModel.trendingNewsFeedBRelay.asObservable()
    }
    
    func latestFeedDataBinding() {
        newsFeedModel.category = category
        newsFeedModel.page = page
        newsFeedModel.query = query
        
        newsFeedModel.latestFeedModelApi()
        
        latestNewsFeedBRObservable = newsFeedModel.latestNewsFeedBRelay.asObservable()
    }
}
