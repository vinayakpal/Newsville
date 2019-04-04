//
//  NewsFeedMapper.swift
//  Newsville
//
//  Created by Vinayak Pal on 04/04/19.
//  Copyright © 2019 Vinayak Pal. All rights reserved.
//

import Foundation
import ObjectMapper

// JSON decoding done by object mapper from API response
class NewsFeedMap: Mappable {
    
    var status: String = ""
    var totalResult: Int64 = 0
    var article: [NewsArticleData]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        status      <- map["status"]
        totalResult <- map["totalResults"]
        article     <- map["articles"]
    }
}

class NewsArticleData: Mappable {
    
    var source: NewsArticleSource?
    var author: String = ""
    var title: String = ""
    var description: String = ""
    var feedUrl: String = ""
    var imageUrl: String = ""
    var publishedAt: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        source      <- map["source"]
        author      <- map["author"]
        title       <- map["title"]
        description <- map["description"]
        feedUrl     <- map["url"]
        imageUrl    <- map["urlToImage"]
        publishedAt <- map["publishedAt"]
    }
}

class NewsArticleSource: Mappable {
    
    var name: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        name <- map["name"]
    }
}
