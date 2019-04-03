//
//  OnboardingVC.swift
//  Newsville
//
//  Created by Vinayak Pal on 03/04/19.
//  Copyright © 2019 Vinayak Pal. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingVC: UIViewController {

    @IBOutlet weak var onboardingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnboarding()
        // Do any additional setup after loading the view.
    }
    
    //intialise onboarding library
    func setupOnboarding() {
        
        let onboarding = PaperOnboarding()
        onboarding.dataSource = self
        onboarding.delegate = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(onboarding)
        
        // add constraints
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
}

// extension for PaperOnboarding datasource methods
extension OnboardingVC: PaperOnboardingDataSource {
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        let trendingItem = OnboardingItemInfo(informationImage: UIImage(named: "fire")!, title: "Top Headlines", description: "Get the latest top headlines", pageIcon: UIImage(), color: UIColor(hex: "2E6EC8"), titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: UIFont(name: "Ubuntu-Bold", size: 22) ?? UIFont(), descriptionFont: UIFont(name: "Ubuntu-Regular", size: 14) ?? UIFont())
        
        let searchItem = OnboardingItemInfo(informationImage: UIImage(named: "search")!, title: "Search", description: "Search any kind of news", pageIcon: UIImage(), color: UIColor(hex: "FFC107"), titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: UIFont(name: "Ubuntu-Bold", size: 22) ?? UIFont(), descriptionFont: UIFont(name: "Ubuntu-Regular", size: 14) ?? UIFont())
        
        let getStartedItem = OnboardingItemInfo(informationImage: UIImage(named: "swipe")!, title: "Get Started", description: "Swipe left to Get Started", pageIcon: UIImage(), color: UIColor(hex: "FF005F"), titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: UIFont(name: "Ubuntu-Bold", size: 22) ?? UIFont(), descriptionFont: UIFont(name: "Ubuntu-Regular", size: 14) ?? UIFont())
        
        return [trendingItem,searchItem,getStartedItem] [index]
        
    }
    
}

// extension for PaperOnboarding delegate methods
extension OnboardingVC: PaperOnboardingDelegate {
    
    func onboardingWillTransitonToLeaving() {
        
        print("leaving")
    }
}
