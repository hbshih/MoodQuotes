//
//  OnboardingViewController.swift
//  句句
//
//  Created by Ben on 2020/11/22.
//

import UIKit
import Onboard
import BLTNBoard

class OnboardingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let firstPage = OnboardingContentViewController(title: "Page Title", body: "Page body goes here.", image: UIImage(named: "icon"), buttonText: "Text For Button") { () -> Void in
            // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
            }
        
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
