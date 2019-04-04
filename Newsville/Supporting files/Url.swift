//
//  Url.swift
//  Newsville
//
//  Created by Vinayak Pal on 04/04/19.
//  Copyright © 2019 Vinayak Pal. All rights reserved.
//

import Foundation

protocol Url {
    
    var urlScheme: String {get}
    var urlHost: String {get}
    var urlPath: String {get}
    var queryKeys: [String] {get}
    var queryValues: [Any] {get}
    
    func createUrlString() -> String
}

// Get Api for trending News
class GetTrendingNewsApi: Url {
    
    var urlScheme: String = Constants.urlScreme
    var urlHost: String = Constants.urlHost
    var urlPath: String = "/v2/everything"
    var queryKeys: [String] = []
    var queryValues: [Any] = []
    
    var queryArray: [URLQueryItem] = []
    
    func createUrlString() -> String {
        var urlComponent = URLComponents()
        
        urlComponent.scheme = urlScheme
        urlComponent.host = urlHost
        urlComponent.path = urlPath
        
        // crete query array
        for entity in 0..<queryKeys.count {
            let queryItem = URLQueryItem(name: queryKeys[entity], value: queryValues[entity] as? String)
            queryArray.append(queryItem)
        }
        
        urlComponent.queryItems = queryArray
        
        let url = urlComponent.url
        
        return url?.absoluteString ?? ""
    }
}

// Get Api for top news
class GetLatestNewsApi: Url {
    var urlScheme: String = Constants.urlScreme
    var urlHost: String = Constants.urlHost
    var urlPath: String = "/v2/top-headlines"
    var queryKeys: [String] = []
    var queryValues: [Any] = []
    
    var queryArray: [URLQueryItem] = []
    
    func createUrlString() -> String {
        var urlComponent = URLComponents()
        
        urlComponent.scheme = urlScheme
        urlComponent.host = urlHost
        urlComponent.path = urlPath
        
        // crete query array
        for entity in 0..<queryKeys.count {
            let queryItem = URLQueryItem(name: queryKeys[entity], value: queryValues[entity] as? String)
            queryArray.append(queryItem)
        }
        
        urlComponent.queryItems = queryArray
        
        let url = urlComponent.url
        
        return url?.absoluteString ?? ""
    }
}
