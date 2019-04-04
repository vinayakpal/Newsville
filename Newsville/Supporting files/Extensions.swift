//
//  Extensions.swift
//  Newsville
//
//  Created by Vinayak Pal on 03/04/19.
//  Copyright © 2019 Vinayak Pal. All rights reserved.
//

import Foundation
import UIKit
import KINWebBrowser

// extension for defining colour in hex
extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let red = (rgbValue & 0xff0000) >> 16
        let green = (rgbValue & 0xff00) >> 8
        let blue = rgbValue & 0xff
        
        self.init(
            red: CGFloat(red) / 0xff,
            green: CGFloat(green) / 0xff,
            blue: CGFloat(blue) / 0xff, alpha: 1
        )
    }
}

extension UIViewController {
    // open in app url scheme
    func openUrl ( urlString : String) {
        
        let webBroswer = KINWebBrowserViewController.webBrowser()
        self.navigationController?.pushViewController(webBroswer!, animated: true)
        webBroswer?.showsURLInNavigationBar = true
        webBroswer?.showsPageTitleInNavigationBar = true
        webBroswer?.load(URL(string : urlString))
        webBroswer?.tintColor = UIColor.black
        webBroswer?.delegate = self
    }
}

extension UIViewController : KINWebBrowserDelegate {
    public func webBrowser(_ webBrowser: KINWebBrowserViewController!, didStartLoading URL: URL!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public func webBrowser(_ webBrowser: KINWebBrowserViewController!, didFinishLoading URL: URL!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
//        let urlStr = NSString(format : "%@",URL! as CVarArg)
//
//        if (!(urlStr.range(of: "twitter").location == NSNotFound)) {
//            let match = ".com/"
//            var pretel : NSString?
//            var postTel : NSString?
//            let scanner = Scanner.init(string: urlStr as String)
//
//            scanner.scanUpTo(match, into: &pretel)
//            scanner.scanString(match, into: nil)
//            postTel = urlStr.substring(from: scanner.scanLocation) as NSString
//
//            webBrowser.title = String(format : "Twitter | @%@",postTel ?? "")
//
//        }
        
    }
    
    public func webBrowser(_ webBrowser: KINWebBrowserViewController!, didFailToLoad URL: URL!, error: Error!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if error != nil {
            webBrowser.title = "Web Page fail to load"
        }
    }
}
