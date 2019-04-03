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
    
    func launchSplashScreen() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            self.moveAheadInApp()
        }
    }
    
    // runs after animation complete
    func moveAheadInApp() {
        //let delegate = UIApplication.shared.delegate as! AppDelegate
    
        if let isOnboardingDone = UserDefaults.standard.value(forKey: Constants.onboarding) as? Bool, isOnboardingDone {
            // Directly enters into Home screen
            
        }else {
            // GO to onboarding screen
            let storyBoard = UIStoryboard(name: "Onboarding", bundle: nil)
            let onboarding = storyBoard.instantiateViewController(withIdentifier: "OnboardingVC") as! OnboardingVC
            //delegate.window?.rootViewController = onboarding
            
            guard let window = UIApplication.shared.keyWindow else {return}
 
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = onboarding
            }, completion: { completed in
                // maybe do something here
            })
        }
    }
}
