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
    
    // tableview header for adding shimmer loader
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
    
    // tableview header for removing shimmer loader
    func removeShimmerHeader(of tableView: UITableView) {
        let nib = UIView()
        nib.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
        tableView.tableHeaderView = nib
        
    }
    
    // tableview footer for adding shimmer loader
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
    
    // tableview footer for removing shimmer loader
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
    
    // converting formatted time String to readable time format
    func feedPublished(at publishedTime : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let dateString = dateFormatter.date(from: publishedTime)
        guard let timeStemp = dateString?.timeIntervalSince1970 else {return ""}
        
        var timeElapsed : String = ""
        let currentTime = Int64(Date().timeIntervalSince1970 * 1000)
        let feedPublishedTime = Int64(timeStemp * 1000)
        
        let miliTime : TimeInterval  = TimeInterval(currentTime - feedPublishedTime)
        
        let noOfSec = miliTime / 1000
        
        let sec    : Int = Int(fabs(noOfSec))
        let min    : Int = sec / 60
        let hours  : Int = min / 60
        let days   : Int = hours / 24
        let weeks  : Int = days / 7
        let months : Int = days / 30
        let years  : Int = days / 365
        
        if years == 0 {
            if months == 0 {
                if weeks == 0 {
                    if days == 0 {
                        if hours == 0 {
                            if min == 0 {
                                timeElapsed = String(format : "%d sec ago",sec)
                            }else {
                                timeElapsed = String(format: "%d min ago",min)
                            }
                        }else {
                            if hours == 1 {
                                timeElapsed = String(format : "%d hr ago",hours)
                            }else {
                                timeElapsed = String(format: "%d hrs ago",hours)
                            }
                        }
                    }else {
                        if days == 1 {
                            timeElapsed = String(format : "%d day ago",days)
                        }else {
                            timeElapsed = String(format: "%d days ago",days)
                        }
                    }
                }else {
                    if weeks == 1 {
                        timeElapsed = String(format : "%d week ago",weeks)
                    }else {
                        timeElapsed = String(format: "%d weeks ago",weeks)
                    }
                }
            }else {
                if months == 1 {
                    timeElapsed = String(format : "%d month ago",months)
                }else {
                    timeElapsed = String(format: "%d months ago",months)
                }
            }
        }else {
            if years == 1 {
                timeElapsed = String(format : "%d year ago",years)
            }else {
                timeElapsed = String(format: "%d years ago",years)
            }
        }
        
        return timeElapsed
        
    }
}

// Dategate methods for in App browser
extension UIViewController : KINWebBrowserDelegate {
    public func webBrowser(_ webBrowser: KINWebBrowserViewController!, didStartLoading URL: URL!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    public func webBrowser(_ webBrowser: KINWebBrowserViewController!, didFinishLoading URL: URL!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
    }
    
    public func webBrowser(_ webBrowser: KINWebBrowserViewController!, didFailToLoad URL: URL!, error: Error!) {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if error != nil {
            webBrowser.title = "Web Page fail to load"
        }
    }
}
