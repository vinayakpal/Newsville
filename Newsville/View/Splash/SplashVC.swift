//
//  SplashVC.swift
//  Newsville
//
//  Created by Vinayak Pal on 03/04/19.
//  Copyright © 2019 Vinayak Pal. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        launchSplashScreen()
        // Do any additional setup after loading the view.
    }
    
    // launch splash with delay to display logo
    func launchSplashScreen() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.moveAheadInApp()
        }
    }
    
    // runs after animation complete
    func moveAheadInApp() {
        // check condition wheather onboarding screen launch or not
        let isOnboardingLaunch = UserDefaults.standard.value(forKey: Constants.onboarding) as? Bool ?? false
        
        let sbOnboarding = UIStoryboard(name: "Onboarding", bundle: nil)
        let onboarding = sbOnboarding.instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
        let sbSidePanel = UIStoryboard(name: "Home", bundle: nil)
        let sidePanel = sbSidePanel.instantiateViewController(withIdentifier: "SidePanelVC") as! SidePanelVC

        guard let window = UIApplication.shared.keyWindow else {return}

        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            
            if isOnboardingLaunch {
                window.rootViewController = sidePanel
            } else {
                window.rootViewController = onboarding
            }
        }, completion: { completed in
            // maybe do something here
        })
    }
}
