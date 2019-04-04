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
    
    // set title and subtitle on Navbar
    func setTitle(title:String, subtitle:String) -> UIView {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.init(name: "Ubuntu-Regular", size: 12)
        titleLabel.text = title
        titleLabel.sizeToFit()
        
        let subtitleLabel = UILabel(frame: CGRect(x: 0, y: 20, width: 0, height: 0))
        subtitleLabel.backgroundColor = UIColor.clear
        subtitleLabel.textColor = UIColor.black
        subtitleLabel.font = UIFont.init(name: "Ubuntu-Bold", size: 16)
        subtitleLabel.text = subtitle
        subtitleLabel.lineBreakMode = NSLineBreakMode.byTruncatingMiddle
        subtitleLabel.sizeToFit()
        
        let maxWidth = self.view.frame.width * 0.7
        
        if subtitleLabel.frame.size.width > maxWidth {
            subtitleLabel.frame.size.width = maxWidth
        }
        
        let titleView = UIView(frame: CGRect(x:0,y:0,width: max(titleLabel.frame.size.width, subtitleLabel.frame.size.width),height: 50))
        
        
        
        //titleView.backgroundColor = Colors.blackColor
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        let widthDiff = subtitleLabel.frame.size.width - titleLabel.frame.size.width
        
        if widthDiff < 0 {
            let newX = widthDiff / 2
            subtitleLabel.frame.origin.x = abs(newX)
        } else {
            let newX = widthDiff / 2
            titleLabel.frame.origin.x = newX
        }
        
        return titleView
    }
    
    func addShimmerHeader(of tableView: UITableView) {
        let nib = UIView()
        let nibView = Bundle.main.loadNibNamed("LatestFeedPlaceholder", owner: self, options: nil)?.first as! LatestFeedPlaceholder
        nibView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 370)
        nibView.l1.startShimmering()
        nibView.l2.startShimmering()
        nibView.l3.startShimmering()
        nibView.l4.startShimmering()
        nibView.l5.startShimmering()
        nibView.l6.startShimmering()
        nibView.l7.startShimmering()
        nibView.l8.startShimmering()
        nib.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 370)
        nib.addSubview(nibView)
        tableView.tableHeaderView = nib
        
    }
    
    func removeShimmerHeader(of tableView: UITableView) {
        let nib = UIView()
        nib.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
        tableView.tableHeaderView = nib
        
    }
    
    func addShimmerFooter(of tableView: UITableView) {
        let bottomNib = UIView()
        let nibView = Bundle.main.loadNibNamed("LatestFeedPlaceholder", owner: self, options: nil)?.first as! LatestFeedPlaceholder
        nibView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 370)
        nibView.l1.startShimmering()
        nibView.l2.startShimmering()
        nibView.l3.startShimmering()
        nibView.l4.startShimmering()
        nibView.l5.startShimmering()
        nibView.l6.startShimmering()
        nibView.l7.startShimmering()
        nibView.l8.startShimmering()
        
        bottomNib.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 370)
        bottomNib.addSubview(nibView)
        tableView.tableFooterView = bottomNib
        
    }
    
    func removeShimmerFooter(of tableView: UITableView) {
        
        let nib = UIView()
        nib.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
        tableView.tableFooterView = nib
        
    }
    
    // show alert control
    func showAlert(msg : String){
        let alertController = UIAlertController(title: "Newsville", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
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
