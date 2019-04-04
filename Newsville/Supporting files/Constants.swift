//
//  Constants.swift
//  Newsville
//
//  Created by Vinayak Pal on 03/04/19.
//  Copyright © 2019 Vinayak Pal. All rights reserved.
//

import Foundation

struct Constants {
    static let onboarding = "onboarding"
    static let apiKey = "05e061dec0654206911ad3ea341b4acd"
    static let urlScreme = "https"
    static let urlHost = "newsapi.org"
    static let header: [String:String] = ["Content-Type":"application/json"]
    static let feedUnavailable = "noFeedAvailable"
    static let networkError = "networkError"
    
}

struct Category {
    static let list : [[String: String]] = [
        
        ["name": "business","colour": "9c27b0"],
        ["name": "general","colour": "673ab7"],
        ["name": "health","colour": "009688"],
        ["name": "science","colour": "ff9800"],
        ["name": "sports","colour": "2196f3"],
        ["name": "technology","colour": "cddc39"]
    ]
}
